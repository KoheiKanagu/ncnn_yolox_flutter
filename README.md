# ncnn_yolox_flutter

This is a plugin to run YOLOX on ncnn.

## Demo

### on Android

<https://user-images.githubusercontent.com/6175794/174544914-f9f4c0ca-2b52-41a5-880a-171decb2a514.mp4>

<https://user-images.githubusercontent.com/6175794/174544918-27505730-7182-48b7-a6e1-1aea457bb522.mp4>

<https://user-images.githubusercontent.com/6175794/174544922-f59d4e45-b350-48c2-9c2a-bf0e2a8901c3.mp4>

### on iOS

<https://user-images.githubusercontent.com/6175794/174546823-6094f13c-c6bc-4433-a165-09b1810c0818.mov>

<https://user-images.githubusercontent.com/6175794/174544939-49609582-c305-4a39-ac98-2e6f24fc4b69.MP4>

<https://user-images.githubusercontent.com/6175794/174544949-177c3306-98c8-4d65-9528-dabec5c3df55.MP4>

## How to use

### 1. Add the YOLOX model to assets

For example, you can use [yolox_onnx_to_ncnn.ipynb](notebooks/yolox_onnx_to_ncnn.ipynb)

**Note that you will need to manually modify the model.**

---

If you want to use yolox_tiny, you can find it in [example/assets/yolox](example/assets/yolox).

---

Don't forget to add the model of assets to your `pubspec.yaml`.

```pubspec.yaml
flutter:
  assets:
    - assets/yolox/
```

### 2. Load the model

```dart
final ncnn = NcnnYolox();

ncnn.initYolox(
  modelPath: 'assets/yolox/yolox.bin',
  paramPath: 'assets/yolox/yolox.param',
);
```

### 3. Get the result

```dart
/// When using image file
/// **Exif Orientation is ignored**
_results = ncnn.detect(
  imagePath: "path",
);

/// When using image pixels
_results = ncnn.detect(
  pixels: image.pixels,
  pixelFormat: PixelFormat.bgra,
  width: image.width,
  height: image.height,
);
```

Please check [example/lib/providers/ncnn_yolox_controller.dart](example/lib/providers/ncnn_yolox_controller.dart) for specific usage.

## How to set up for using custom ncnn and custom YOLOX model

### 1. Build ncnn

See [build_ncnn.yaml](.github/workflows/build_ncnn.yaml) for details.

If you want pre-built ncnn, look at the URL of the Releases referenced in these files.
Such as this `https://github.com/KoheiKanagu/ncnn_yolox_flutter/releases/download/x.y.z/ncnn-android.zip`

- [android/CMakeLists.txt](https://github.com/KoheiKanagu/ncnn_yolox_flutter/blob/main/android/CMakeLists.txt)
- [ios/ncnn_yolox_flutter.podspec](https://github.com/KoheiKanagu/ncnn_yolox_flutter/blob/main/ios/ncnn_yolox_flutter.podspec)

### 2. Download ncnn

The library is a binary file, so it is not packaged in the repository.
The ncnn libraries for iOS and Android are CMake and Cocoapods, downloaded from Github Releases.

- [android/CMakeLists.txt](android/CMakeLists.txt)
- [ios/ncnn_yolox_flutter.podspec](ios/ncnn_yolox_flutter.podspec)

The ncnn library zip you are downloading is the artifact of [build_ncnn.yaml](.github/workflows/build_ncnn.yaml). Change the URL if you want.

---

If you do not want to download the ncnn library, remove the process of downloading the zip.
Then install the ncnn library manually.

Please refer to the comments in these files.

- [android/CMakeLists.txt](android/CMakeLists.txt)
- [ios/ncnn_yolox_flutter.podspec](ios/ncnn_yolox_flutter.podspec)

### 3. Change the parameters of YOLOX

Change [ios/Classes/yolox.cpp](ios/Classes/yolox.cpp) if you want.

For example, if you want to change the size of the input image, change `YOLOX_TARGET_SIZE`.

Alternatively, you can change the `ncnn::Net yolox;` in the `void initYolox(char *modelPath, char *paramPath)` method.

---

The original `yolox.cpp` is [ncnn/yolox\.cpp at 20220216 · Tencent/ncnn](https://github.com/Tencent/ncnn/blob/20220216/examples/yolox.cpp).
