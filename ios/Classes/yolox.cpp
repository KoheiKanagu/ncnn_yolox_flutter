// This file is wirtten base on the following file:
// https://github.com/Tencent/ncnn/blob/master/examples/yolov5.cpp
// Copyright (C) 2020 THL A29 Limited, a Tencent company. All rights reserved.
// Licensed under the BSD 3-Clause License (the "License"); you may not use this file except
// in compliance with the License. You may obtain a copy of the License at
//
// https://opensource.org/licenses/BSD-3-Clause
//
// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
// ------------------------------------------------------------------------------
// Copyright (C) 2020-2021, Megvii Inc. All rights reserved.

#if defined(NCNN_YOLOX_FLUTTER_IOS)
#include "ncnn/ncnn/layer.h"
#include "ncnn/ncnn/net.h"
#else
#include "layer.h"
#include "net.h"
#endif

#if defined(USE_NCNN_SIMPLEOCV)
#if defined(NCNN_YOLOX_FLUTTER_IOS)
#include "ncnn/ncnn/simpleocv.h"
#else
#include "simpleocv.h"
#endif
#else
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#endif
#include <float.h>
#include <stdio.h>
#include <vector>

ncnn::Net yolox;

// YOLOX use the same focus in yolov5
class YoloV5Focus : public ncnn::Layer
{
public:
    YoloV5Focus()
    {
        one_blob_only = true;
    }

    virtual int forward(const ncnn::Mat& bottom_blob, ncnn::Mat& top_blob, const ncnn::Option& opt) const
    {
        int w = bottom_blob.w;
        int h = bottom_blob.h;
        int channels = bottom_blob.c;

        int outw = w / 2;
        int outh = h / 2;
        int outc = channels * 4;

        top_blob.create(outw, outh, outc, 4u, 1, opt.blob_allocator);
        if (top_blob.empty())
            return -100;

        #pragma omp parallel for num_threads(opt.num_threads)
        for (int p = 0; p < outc; p++)
        {
            const float* ptr = bottom_blob.channel(p % channels).row((p / channels) % 2) + ((p / channels) / 2);
            float* outptr = top_blob.channel(p);

            for (int i = 0; i < outh; i++)
            {
                for (int j = 0; j < outw; j++)
                {
                    *outptr = *ptr;

                    outptr += 1;
                    ptr += 2;
                }

                ptr += w;
            }
        }

        return 0;
    }
};

DEFINE_LAYER_CREATOR(YoloV5Focus)

struct Object
{
    cv::Rect_<float> rect;
    int label;
    float prob;
};

struct GridAndStride
{
    int grid0;
    int grid1;
    int stride;
};

static inline float intersection_area(const Object& a, const Object& b)
{
    cv::Rect_<float> inter = a.rect & b.rect;
    return inter.area();
}

static void qsort_descent_inplace(std::vector<Object>& faceobjects, int left, int right)
{
    int i = left;
    int j = right;
    float p = faceobjects[(left + right) / 2].prob;

    while (i <= j)
    {
        while (faceobjects[i].prob > p)
            i++;

        while (faceobjects[j].prob < p)
            j--;

        if (i <= j)
        {
            // swap
            std::swap(faceobjects[i], faceobjects[j]);

            i++;
            j--;
        }
    }

    #pragma omp parallel sections
    {
        #pragma omp section
        {
            if (left < j) qsort_descent_inplace(faceobjects, left, j);
        }
        #pragma omp section
        {
            if (i < right) qsort_descent_inplace(faceobjects, i, right);
        }
    }
}

static void qsort_descent_inplace(std::vector<Object>& objects)
{
    if (objects.empty())
        return;

    qsort_descent_inplace(objects, 0, objects.size() - 1);
}

static void nms_sorted_bboxes(const std::vector<Object>& faceobjects, std::vector<int>& picked, float nms_threshold)
{
    picked.clear();

    const int n = faceobjects.size();

    std::vector<float> areas(n);
    for (int i = 0; i < n; i++)
    {
        areas[i] = faceobjects[i].rect.area();
    }

    for (int i = 0; i < n; i++)
    {
        const Object& a = faceobjects[i];

        int keep = 1;
        for (int j = 0; j < (int)picked.size(); j++)
        {
            const Object& b = faceobjects[picked[j]];

            // intersection over union
            float inter_area = intersection_area(a, b);
            float union_area = areas[i] + areas[picked[j]] - inter_area;
            // float IoU = inter_area / union_area
            if (inter_area / union_area > nms_threshold)
                keep = 0;
        }

        if (keep)
            picked.push_back(i);
    }
}

static void generate_grids_and_stride(const int target_size, std::vector<int>& strides, std::vector<GridAndStride>& grid_strides)
{
    for (int i = 0; i < (int)strides.size(); i++)
    {
        int stride = strides[i];
        int num_grid = target_size / stride;
        for (int g1 = 0; g1 < num_grid; g1++)
        {
            for (int g0 = 0; g0 < num_grid; g0++)
            {
                GridAndStride gs;
                gs.grid0 = g0;
                gs.grid1 = g1;
                gs.stride = stride;
                grid_strides.push_back(gs);
            }
        }
    }
}

static void generate_yolox_proposals(std::vector<GridAndStride> grid_strides, const ncnn::Mat& feat_blob, float prob_threshold, std::vector<Object>& objects)
{
    const int num_grid = feat_blob.h;
    const int num_class = feat_blob.w - 5;
    const int num_anchors = grid_strides.size();

    const float* feat_ptr = feat_blob.channel(0);
    for (int anchor_idx = 0; anchor_idx < num_anchors; anchor_idx++)
    {
        const int grid0 = grid_strides[anchor_idx].grid0;
        const int grid1 = grid_strides[anchor_idx].grid1;
        const int stride = grid_strides[anchor_idx].stride;

        // yolox/models/yolo_head.py decode logic
        //  outputs[..., :2] = (outputs[..., :2] + grids) * strides
        //  outputs[..., 2:4] = torch.exp(outputs[..., 2:4]) * strides
        float x_center = (feat_ptr[0] + grid0) * stride;
        float y_center = (feat_ptr[1] + grid1) * stride;
        float w = exp(feat_ptr[2]) * stride;
        float h = exp(feat_ptr[3]) * stride;
        float x0 = x_center - w * 0.5f;
        float y0 = y_center - h * 0.5f;

        float box_objectness = feat_ptr[4];
        for (int class_idx = 0; class_idx < num_class; class_idx++)
        {
            float box_cls_score = feat_ptr[5 + class_idx];
            float box_prob = box_objectness * box_cls_score;
            if (box_prob > prob_threshold)
            {
                Object obj;
                obj.rect.x = x0;
                obj.rect.y = y0;
                obj.rect.width = w;
                obj.rect.height = h;
                obj.label = class_idx;
                obj.prob = box_prob;

                objects.push_back(obj);
            }

        } // class loop
        feat_ptr += feat_blob.w;

    } // point anchor loop
}

static int detect_yolox(const unsigned char *pixels, int type, int img_w, int img_h, double nms_thresh, double conf_thresh, int target_size, std::vector<Object> &objects)
{
    int w = img_w;
    int h = img_h;
    float scale = 1.f;
    if (w > h)
    {
        scale = (float)target_size / w;
        w = target_size;
        h = h * scale;
    }
    else
    {
        scale = (float)target_size / h;
        h = target_size;
        w = w * scale;
    }

    ncnn::Mat in = ncnn::Mat::from_pixels_resize(pixels, type, img_w, img_h, w, h);

    // pad to target_size rectangle
    int wpad = target_size - w;
    int hpad = target_size - h;
    ncnn::Mat in_pad;
    // different from yolov5, yolox only pad on bottom and right side,
    // which means users don't need to extra padding info to decode boxes coordinate.
    ncnn::copy_make_border(in, in_pad, 0, hpad, 0, wpad, ncnn::BORDER_CONSTANT, 114.f);

    ncnn::Extractor ex = yolox.create_extractor();

    ex.input("images", in_pad);

    std::vector<Object> proposals;

    {
        ncnn::Mat out;
        ex.extract("output", out);

        static const int stride_arr[] = {8, 16, 32}; // might have stride=64 in YOLOX
        std::vector<int> strides(stride_arr, stride_arr + sizeof(stride_arr) / sizeof(stride_arr[0]));
        std::vector<GridAndStride> grid_strides;
        generate_grids_and_stride(target_size, strides, grid_strides);
        generate_yolox_proposals(grid_strides, out, conf_thresh, proposals);
    }

    // sort all proposals by score from highest to lowest
    qsort_descent_inplace(proposals);

    // apply nms with nms_threshold
    std::vector<int> picked;
    nms_sorted_bboxes(proposals, picked, nms_thresh);

    int count = picked.size();

    objects.resize(count);
    for (int i = 0; i < count; i++)
    {
        objects[i] = proposals[picked[i]];

        // adjust offset to original unpadded
        float x0 = (objects[i].rect.x) / scale;
        float y0 = (objects[i].rect.y) / scale;
        float x1 = (objects[i].rect.x + objects[i].rect.width) / scale;
        float y1 = (objects[i].rect.y + objects[i].rect.height) / scale;

        // clip
        x0 = std::max(std::min(x0, (float)(img_w - 1)), 0.f);
        y0 = std::max(std::min(y0, (float)(img_h - 1)), 0.f);
        x1 = std::max(std::min(x1, (float)(img_w - 1)), 0.f);
        y1 = std::max(std::min(y1, (float)(img_h - 1)), 0.f);

        objects[i].rect.x = x0;
        objects[i].rect.y = y0;
        objects[i].rect.width = x1 - x0;
        objects[i].rect.height = y1 - y0;
    }

    return 0;
}

static int detect_yolox_cv_mat(const cv::Mat &bgr, double nms_thresh, double conf_thresh, int target_size, std::vector<Object> &objects)
{
    int img_w = bgr.cols;
    int img_h = bgr.rows;
    return detect_yolox(bgr.data, ncnn::Mat::PIXEL_BGR, img_w, img_h, nms_thresh, conf_thresh, target_size, objects);
}

static int detect_yolox_pixels(const unsigned char *pixels, int pixelType, int img_w, int img_h, double nms_thresh, double conf_thresh, int target_size, std::vector<Object> &objects)
{
    // https://github.com/Tencent/ncnn/blob/master/docs/how-to-use-and-FAQ/FAQ-ncnn-produce-wrong-result.md#check-input-is-rgb-or-bgr
    return detect_yolox(pixels, pixelType, img_w, img_h, nms_thresh, conf_thresh, target_size, objects);
}

static void draw_objects(const cv::Mat& bgr, const std::vector<Object>& objects)
{
    static const char* class_names[] = {
        "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat", "traffic light",
        "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat", "dog", "horse", "sheep", "cow",
        "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee",
        "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard",
        "tennis racket", "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple",
        "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "couch",
        "potted plant", "bed", "dining table", "toilet", "tv", "laptop", "mouse", "remote", "keyboard", "cell phone",
        "microwave", "oven", "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors", "teddy bear",
        "hair drier", "toothbrush"
    };

    cv::Mat image = bgr.clone();

    for (size_t i = 0; i < objects.size(); i++)
    {
        const Object& obj = objects[i];

        fprintf(stderr, "%d = %.5f at %.2f %.2f %.2f x %.2f\n", obj.label, obj.prob,
                obj.rect.x, obj.rect.y, obj.rect.width, obj.rect.height);

        cv::rectangle(image, obj.rect, cv::Scalar(255, 0, 0));

        char text[256];
        sprintf(text, "%s %.1f%%", class_names[obj.label], obj.prob * 100);

        int baseLine = 0;
        cv::Size label_size = cv::getTextSize(text, cv::FONT_HERSHEY_SIMPLEX, 0.5, 1, &baseLine);

        int x = obj.rect.x;
        int y = obj.rect.y - label_size.height - baseLine;
        if (y < 0)
            y = 0;
        if (x + label_size.width > image.cols)
            x = image.cols - label_size.width;

        cv::rectangle(image, cv::Rect(cv::Point(x, y), cv::Size(label_size.width, label_size.height + baseLine)),
                      cv::Scalar(255, 255, 255), -1);

        cv::putText(image, text, cv::Point(x, y + label_size.height),
                    cv::FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 0, 0));
    }

    cv::imshow("image", image);
    cv::waitKey(0);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) void initYolox(char *modelPath, char *paramPath)
{
    // Focus in yolov5
    yolox.register_custom_layer("YoloV5Focus", YoloV5Focus_layer_creator);

    // original pretrained model from https://github.com/Megvii-BaseDetection/YOLOX
    // ncnn model param: https://github.com/Megvii-BaseDetection/YOLOX/releases/download/0.1.1rc0/yolox_s_ncnn.tar.gz
    // NOTE that newest version YOLOX remove normalization of model (minus mean and then div by std),
    // which might cause your model outputs becoming a total mess, plz check carefully.
    yolox.load_param(paramPath);
    yolox.load_model(modelPath);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) void disposeYolox()
{
    yolox.clear();
}

char *parseResultsObjects(std::vector<Object> &objects)
{
    if (objects.size() == 0)
    {
        NCNN_LOGE("No object detected");
        return (char *)"";
    }

    std::string result = "";
    for (int i = 0; i < (int)objects.size(); i++)
    {
        Object obj = objects[i];
        result += std::to_string(obj.rect.x) + "," + std::to_string(obj.rect.y) + "," + std::to_string(obj.rect.width) + "," + std::to_string(obj.rect.height) + "," + std::to_string(obj.label) + "," + std::to_string(obj.prob) + "\n";
    }

    char *result_c = new char[result.length() + 1];
    strcpy(result_c, result.c_str());
    return result_c;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) char *detectWithImagePath(char *imagepath, double nms_thresh, double conf_thresh, int target_size)
{
    cv::Mat m = cv::imread(imagepath, 1);

    // Exit if the image does not load.
    if (m.empty())
    {
        NCNN_LOGE("cv::imread %s failed", imagepath);
        return (char *)"";
    }

    std::vector<Object> objects;
    detect_yolox_cv_mat(m, nms_thresh, conf_thresh, target_size, objects);

    return parseResultsObjects(objects);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) char *detectWithPixels(const unsigned char *pixels, int pixelType, int width, int height, double nms_thresh, double conf_thresh, int target_size)
{
    std::vector<Object> objects;
    detect_yolox_pixels(pixels, pixelType, width, height, nms_thresh, conf_thresh, target_size, objects);

    return parseResultsObjects(objects);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) void yuv420sp2rgb(const unsigned char *yuv420sp, int width, int height, unsigned char *rgb)
{
    ncnn::yuv420sp2rgb(yuv420sp, width, height, rgb);
    return;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) void rgb2rgba(const unsigned char *rgb, int width, int height, unsigned char *rgba)
{
    ncnn::Mat m = ncnn::Mat::from_pixels(rgb, ncnn::Mat::PIXEL_RGB2BGRA, width, height);
    m.to_pixels(rgba, ncnn::Mat::PIXEL_RGBA);
    return;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) void kannaRotate(const unsigned char *src, int channel, int srcw, int srch, unsigned char *dst, int dsw, int dsh, int type)
{
    switch (channel)
    {
    case 1:
        ncnn::kanna_rotate_c1(src, srcw, srch, dst, dsw, dsh, type);
        break;
    case 2:
        ncnn::kanna_rotate_c2(src, srcw, srch, dst, dsw, dsh, type);
        break;
    case 3:
        ncnn::kanna_rotate_c3(src, srcw, srch, dst, dsw, dsh, type);
        break;
    case 4:
        ncnn::kanna_rotate_c4(src, srcw, srch, dst, dsw, dsh, type);
        break;
    }
    return;
}
