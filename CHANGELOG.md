## 0.4.2

- Fixed a problem with incorrect object detection on iOS when the image source is camera in the example app. [#83](https://github.com/KoheiKanagu/ncnn_yolox_flutter/pull/83)
- Supports the latest riverpod with example app. [#82](https://github.com/KoheiKanagu/ncnn_yolox_flutter/pull/82)

## 0.4.1

- Added NMS and confidence and image size options to initYolox. [#77](https://github.com/KoheiKanagu/ncnn_yolox_flutter/pull/77)
- Recently loaded model can now be disposed of at any time. By default, recently loaded model is automatically disposed of when initYolox is called again. [#76](https://github.com/KoheiKanagu/ncnn_yolox_flutter/pull/76)

## 0.4.0

- dart 2.18.0 [#72](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/72)
- Fixed a memory leak on model loading [#71](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/71)
- The Width of the stream's CameraImage is width from the length of the pixels. [#45](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/45)
- improvement detect method [#46](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/46)

## 0.3.0

- impl DetectResults [#43](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/43)

## 0.2.0

- Add PixelChannel to KannaRotateResults [#27](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/27)
- Support Flutter3 [#29](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/29)
- refactor example app [#32](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/32)
- support freezed [#33](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/33)
- A new method, detect, has been added for convenience when using CameraImage. [#35](https://github.com/KoheiKanagu/ncnn_yolox_flutter/issues/35)

## 0.1.2

- Fixed to initialize dynamicLibrary lookupFunction in the constructor.

## 0.1.1

- Fixed orientation of preview image in example app.

## 0.1.0

- Can execute YOLOX on `Uint8List` pixel data.
- Helper methods have been implemented to execute YOLOX on image streams.
- Fixed a problem with object detection in the sample app.

## 0.0.7+1

- README fixed

## 0.0.7

- License changed

## 0.0.6

- iOS is now supported.
- Use Github Actions to build ncnn

## 0.0.5

- Fixed a bug that caused an error when an object was not detected.

## 0.0.4

- Fixed a bug that caused an error when an object was not detected.

## 0.0.3

- Class name changed.

## 0.0.2

- Added a method to draw the resulting rectangle of YOLOX to image.
- Change typedef to private.

## 0.0.1

Initial Release.
