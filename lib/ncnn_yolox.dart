// ignore_for_file: prefer_single_quotes, avoid_private_typedef_functions, lines_longer_than_80_chars

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:ncnn_yolox_flutter/models/models.dart';
import 'package:path_provider/path_provider.dart';

/// NMS threshold. Default value reference: https://github.com/Megvii-BaseDetection/YOLOX/blob/d9422393113ffcd381a533e91720bee96652477d/demo/ncnn/cpp/yolox.cpp#L30
const yoloxNmsThreshDefault = 0.45;

/// Threshold of bounding box prob. Default value reference: https://github.com/Megvii-BaseDetection/YOLOX/blob/d9422393113ffcd381a533e91720bee96652477d/demo/ncnn/cpp/yolox.cpp#L31
const yoloxConfThreshDefault = 0.25;

/// Target image size after resize, might use 416 for small model. Default value reference: https://github.com/Megvii-BaseDetection/YOLOX/blob/d9422393113ffcd381a533e91720bee96652477d/demo/ncnn/cpp/yolox.cpp#L32
const yoloxTargetSizeDefault = 416;

typedef _KannaRotateNative = Void Function(
  Pointer<Uint8> src,
  Int8 channel,
  Int32 srcw,
  Int32 srch,
  Pointer<Uint8> dst,
  Int32 dstw,
  Int32 dsth,
  Int8 type,
);

typedef _KannaRotate = void Function(
  Pointer<Uint8> src,
  int channel,
  int srcw,
  int srch,
  Pointer<Uint8> dst,
  int dstw,
  int dsth,
  int type,
);

typedef _Rgb2rgbaNative = Void Function(
  Pointer<Uint8> rgb,
  Int32 width,
  Int32 height,
  Pointer<Uint8> rgba,
);

typedef _Rgb2rgba = void Function(
  Pointer<Uint8> rgb,
  int width,
  int height,
  Pointer<Uint8> rgba,
);

typedef _Yuv420sp2rgbNative = Void Function(
  Pointer<Uint8> yuv420sp,
  Int32 width,
  Int32 height,
  Pointer<Uint8> rgb,
);
typedef _Yuv420sp2rgb = void Function(
  Pointer<Uint8> yuv420sp,
  int width,
  int height,
  Pointer<Uint8> rgb,
);

typedef _DetectWithPixelsYoloxNative = Pointer<Utf8> Function(
  Pointer<Uint8> pixels,
  Int32 pixelFormat,
  Int32 width,
  Int32 height,
  Double nmsThresh,
  Double confThresh,
  Int32 targetSize,
);

typedef _DetectWithPixelsYolox = Pointer<Utf8> Function(
  Pointer<Uint8> pixels,
  int pixelFormat,
  int width,
  int height,
  double nmsThresh,
  double confThresh,
  int targetSize,
);

typedef _DetectWithImagePathYoloxNative = Pointer<Utf8> Function(
  Pointer<Utf8> imagePath,
  Double nmsThresh,
  Double confThresh,
  Int32 targetSize,
);
typedef _DetectWithImagePathYolox = Pointer<Utf8> Function(
  Pointer<Utf8> imagePath,
  double nmsThresh,
  double confThresh,
  int targetSize,
);

typedef _DisposeYoloxNative = Void Function();

typedef _DisposeYolox = void Function();

typedef _InitYoloxNative = Void Function(
  Pointer<Utf8> modelPath,
  Pointer<Utf8> paramPath,
);

typedef _InitYolox = void Function(
  Pointer<Utf8> modelPath,
  Pointer<Utf8> paramPath,
);

class NcnnYolox {
  NcnnYolox() {
    _detectWithImagePathYoloxFunction = dynamicLibrary.lookupFunction<
        _DetectWithImagePathYoloxNative,
        _DetectWithImagePathYolox>('detectWithImagePath');
    _detectWithPixelsYoloxFunction = dynamicLibrary.lookupFunction<
        _DetectWithPixelsYoloxNative,
        _DetectWithPixelsYolox>('detectWithPixels');
    _yuv420sp2rgbFunction = dynamicLibrary
        .lookupFunction<_Yuv420sp2rgbNative, _Yuv420sp2rgb>('yuv420sp2rgb');
    _rgb2rgbaFunction =
        dynamicLibrary.lookupFunction<_Rgb2rgbaNative, _Rgb2rgba>('rgb2rgba');
    _kannaRotateFunction = dynamicLibrary
        .lookupFunction<_KannaRotateNative, _KannaRotate>('kannaRotate');
    _disposeYoloxFunction = dynamicLibrary
        .lookupFunction<_DisposeYoloxNative, _DisposeYolox>("disposeYolox");
    _initYoloxFunction = dynamicLibrary
        .lookupFunction<_InitYoloxNative, _InitYolox>('initYolox');
  }

  final dynamicLibrary = Platform.isAndroid
      ? DynamicLibrary.open('libncnn_yolox_flutter.so')
      : DynamicLibrary.process();

  late _DetectWithImagePathYolox _detectWithImagePathYoloxFunction;
  late _DetectWithPixelsYolox _detectWithPixelsYoloxFunction;
  late _Yuv420sp2rgb _yuv420sp2rgbFunction;
  late _Rgb2rgba _rgb2rgbaFunction;
  late _KannaRotate _kannaRotateFunction;
  late _DisposeYolox _disposeYoloxFunction;
  late _InitYolox _initYoloxFunction;

  /// NMS threshold.
  double _nmsThresh = yoloxNmsThreshDefault;
  double get nmsThresh => _nmsThresh;

  /// Threshold of bounding box prob.
  double _confThresh = yoloxConfThreshDefault;
  double get confThresh => _confThresh;

  /// Target image size after resize.
  int _targetSize = yoloxTargetSizeDefault;
  int get targetSize => _targetSize;

  /// Initialize YOLOX
  /// Run it for the first time
  ///
  /// - [modelPath] - path to model file. like "assets/yolox.bin"
  /// - [paramPath] - path to parameter file. like "assets/yolox.param"
  /// - [autoDispose] - If true, multiple calls to initYolox will automatically dispose of recently loaded model.
  /// - [nmsThresh] NMS threshold.
  /// - [confThresh] Threshold of bounding box prob.
  /// - [targetSize] Target image size after resize, might use 416 for small model.
  Future<void> initYolox({
    required String modelPath,
    required String paramPath,
    bool autoDispose = true,
    double nmsThresh = yoloxNmsThreshDefault,
    double confThresh = yoloxConfThreshDefault,
    int targetSize = yoloxTargetSizeDefault,
  }) async {
    assert(nmsThresh > 0);
    assert(confThresh > 0);
    assert(targetSize > 0);

    if (autoDispose) {
      dispose();
    }
    _nmsThresh = nmsThresh;
    _confThresh = confThresh;
    _targetSize = targetSize;

    final tempModelPath = (await _copy(modelPath)).toNativeUtf8();
    final tempParamPath = (await _copy(paramPath)).toNativeUtf8();

    _initYoloxFunction(
      tempModelPath,
      tempParamPath,
    );
    calloc
      ..free(tempModelPath)
      ..free(tempParamPath);
  }

  /// Dispose of the recently loaded YOLOX model.
  void dispose() {
    _disposeYoloxFunction();
  }

  Future<String> _copy(String assetsPath) async {
    final documentDir = await getApplicationDocumentsDirectory();

    final data = await rootBundle.load(assetsPath);

    final file = File('${documentDir.path}/$assetsPath')
      ..createSync(recursive: true)
      ..writeAsBytesSync(
        data.buffer.asUint8List(),
        flush: true,
      );
    return file.path;
  }

  /// Detect with YOLOX
  /// Run it after initYolox
  ///
  /// When detecting from an image file, specify [imagePath].
  /// The [imagePath] should be the path to the image, such as "assets/image.jpg".
  /// **The Orientation in the Exif of the image file is ignored**.
  /// You may need to rotate the image if the object is not detected successfully.
  ///
  /// When detecting from an image byte array, specify [pixels], [pixelFormat], [height] and [width].
  /// [pixels] is pixel data of the image. [pixelFormat] is the pixel format.
  /// [width] and [height] are the width and height of the image.
  ///
  /// Return a list of [YoloxResults].
  @Deprecated('Use detectImageFile or detectPixels instead')
  List<YoloxResults> detect({
    String? imagePath,
    Uint8List? pixels,
    PixelFormat pixelFormat = PixelFormat.rgb,
    int? width,
    int? height,
  }) {
    if (imagePath != null) {
      return detectImageFile(
        imagePath,
      );
    }

    if (width != null && height != null && pixels != null) {
      return detectPixels(
        pixels: pixels,
        pixelFormat: pixelFormat,
        width: width,
        height: height,
      );
    }

    return [];
  }

  /// Detect with YOLOX
  /// Run it after initYolox
  ///
  /// When detecting from an image byte array, specify [y], [u] and [v].
  /// [y] and [u] and [v] are the YUV420 data of the image.
  /// [height] is the height of the image.
  /// The width of the image is calculated from [y] length.
  ///
  /// [deviceOrientationType] is the device orientation.
  /// It can be obtained from CameraController of the camera package.
  /// https://github.com/flutter/plugins/blob/main/packages/camera/camera/lib/src/camera_controller.dart#L134
  ///
  /// [sensorOrientation] is the orientation of the camera sensor.
  /// It can be obtained from CameraController of the camera package.
  /// https://github.com/flutter/plugins/blob/main/packages/camera/camera_platform_interface/lib/src/types/camera_description.dart#L42
  ///
  /// [onDecodeImage] and [onYuv420sp2rgbImage] are callback functions for decoding images.
  /// The process of converting to a [ui.Image] object is heavy and affects performance.
  /// If [ui.Image] is not needed, it is recommended to set null.
  ///
  DetectResults detectYUV420({
    required Uint8List y,
    required Uint8List u,
    required Uint8List v,
    required int height,
    @Deprecated("width is automatically calculated from the length of the y.")
        int width = 0,
    required KannaRotateDeviceOrientationType deviceOrientationType,
    required int sensorOrientation,
    void Function(ui.Image image)? onDecodeImage,
    void Function(ui.Image image)? onYuv420sp2rgbImage,
  }) {
    final yuv420sp = yuv420sp2Uint8List(
      y: y,
      u: u,
      v: v,
    );

    final width = y.length ~/ height;

    final pixels = yuv420sp2rgb(
      yuv420sp: yuv420sp,
      width: width,
      height: height,
    );
    if (onYuv420sp2rgbImage != null) {
      final rgba = rgb2rgba(
        rgb: pixels,
        width: width,
        height: height,
      );

      ui.decodeImageFromPixels(
        rgba,
        width,
        height,
        ui.PixelFormat.rgba8888,
        onYuv420sp2rgbImage,
      );
    }

    final rotated = kannaRotate(
      pixels: pixels,
      width: width,
      height: height,
      deviceOrientationType: deviceOrientationType,
      sensorOrientation: sensorOrientation,
    );

    if (onDecodeImage != null) {
      final rgba = rgb2rgba(
        rgb: rotated.pixels ?? Uint8List(0),
        width: rotated.width,
        height: rotated.height,
      );

      ui.decodeImageFromPixels(
        rgba,
        rotated.width,
        rotated.height,
        ui.PixelFormat.rgba8888,
        onDecodeImage,
      );
    }

    return DetectResults(
      results: detectPixels(
        pixels: rotated.pixels ?? Uint8List(0),
        width: rotated.width,
        height: rotated.height,
      ),
      image: rotated,
    );
  }

  /// Detect with YOLOX
  /// Run it after initYolox
  ///
  /// When detecting from an image byte array, specify [pixels].
  /// [height] is the height of the image.
  /// The width of the image is calculated from [pixels] length.
  ///
  /// [deviceOrientationType] is the device orientation.
  /// It can be obtained from CameraController of the camera package.
  /// https://github.com/flutter/plugins/blob/main/packages/camera/camera/lib/src/camera_controller.dart#L134
  ///
  /// [sensorOrientation] is the orientation of the camera sensor.
  /// It can be obtained from CameraController of the camera package.
  /// https://github.com/flutter/plugins/blob/main/packages/camera/camera_platform_interface/lib/src/types/camera_description.dart#L42
  ///
  /// [onDecodeImage] is a callback function to decode the image.
  /// The process of converting to a [ui.Image] object is heavy and affects performance.
  /// If [ui.Image] is not needed, it is recommended to set null.
  ///
  DetectResults detectBGRA8888({
    required Uint8List pixels,
    required int height,
    @Deprecated("width is automatically calculated from the length of the pixels.")
        int width = 0,
    required KannaRotateDeviceOrientationType deviceOrientationType,
    required int sensorOrientation,
    void Function(ui.Image image)? onDecodeImage,
  }) {
    final width = pixels.length ~/ height ~/ 4;

    final rotated = kannaRotate(
      pixels: pixels,
      pixelChannel: PixelChannel.c4,
      width: width,
      height: height,
      deviceOrientationType: deviceOrientationType,
      sensorOrientation: sensorOrientation,
    );

    if (onDecodeImage != null) {
      ui.decodeImageFromPixels(
        pixels,
        width,
        height,
        ui.PixelFormat.bgra8888,
        onDecodeImage,
      );
    }

    return DetectResults(
      results: detectPixels(
        pixels: rotated.pixels ?? Uint8List(0),
        pixelFormat: PixelFormat.bgra,
        width: rotated.width,
        height: rotated.height,
      ),
      image: rotated,
    );
  }

  /// Detect with YOLOX
  /// Run it after initYolox
  ///
  /// Reads an image from pixel data and executes Detect.
  ///
  /// [pixels] is pixel data of the image. [pixelFormat] is the pixel format.
  /// [width] and [height] are the width and height of the image.
  ///
  /// Returns a list of [YoloxResults]
  ///
  List<YoloxResults> detectPixels({
    required Uint8List pixels,
    PixelFormat pixelFormat = PixelFormat.rgb,
    required int width,
    required int height,
  }) {
    final pixelsNative = calloc.allocate<Uint8>(pixels.length);

    for (var i = 0; i < pixels.length; i++) {
      pixelsNative[i] = pixels[i];
    }

    final results = YoloxResults.create(
      _detectWithPixelsYoloxFunction(
        pixelsNative,
        pixelFormat.type,
        width,
        height,
        nmsThresh,
        confThresh,
        targetSize,
      ).toDartString(),
    );
    calloc.free(pixelsNative);
    return results;
  }

  /// Detect with YOLOX
  /// Run it after initYolox
  ///
  /// Read the image from the file path and execute Detect.
  ///
  /// The [imagePath] should be the path to the image, such as "assets/image.jpg".
  /// Returns the results of a YOLOX run as a List of [YoloxResults].
  ///
  List<YoloxResults> detectImageFile(
    String imagePath,
  ) {
    assert(imagePath.isNotEmpty, 'imagePath is empty');

    if (imagePath.isEmpty) {
      return [];
    }

    final imagePathNative = imagePath.toNativeUtf8();

    final results = YoloxResults.create(
      _detectWithImagePathYoloxFunction(
        imagePathNative,
        nmsThresh,
        confThresh,
        targetSize,
      ).toDartString(),
    );
    calloc.free(imagePathNative);
    return results;
  }

  /// Converts YUV bytes to a Uint8List of YUV420sp(NV12).
  ///
  /// The use case for this method is when using the camera plugin. https://pub.dev/packages/camera
  /// See example.
  ///
  Uint8List yuv420sp2Uint8List({
    required Uint8List y,
    required Uint8List u,
    required Uint8List v,
  }) {
    assert(y.isNotEmpty, 'y is empty');
    assert(u.isNotEmpty, 'u is empty');
    assert(v.isNotEmpty, 'v is empty');

    final yuv420sp = Uint8List(
      y.length + u.length + v.length,
    );

    /// https://wiki.videolan.org/YUV#Semi-planar
    for (var i = 0; i < y.length; i++) {
      yuv420sp[i] = y[i];
    }

    for (var i = 0; i < u.length; i += 2) {
      yuv420sp[y.length + i] = u[i];
      yuv420sp[y.length + i + 1] = v[i];
    }
    return yuv420sp;
  }

  /// Convert YUV420SP to RGB
  ///
  /// [yuv420sp] is Image data in YUV420SP(NV12) format. [width] and [height] specify the width and height of the Image.
  /// Returns RGB bytes.
  ///
  Uint8List yuv420sp2rgb({
    required Uint8List yuv420sp,
    required int width,
    required int height,
  }) {
    assert(width > 0, 'width is too small');
    assert(height > 0, 'height is too small');
    assert(yuv420sp.isNotEmpty, 'yuv420sp is empty');

    if (width <= 0 || height <= 0 || yuv420sp.isEmpty) {
      return Uint8List(0);
    }

    final pixels = calloc.allocate<Uint8>(yuv420sp.length);
    for (var i = 0; i < yuv420sp.length; i++) {
      pixels[i] = yuv420sp[i];
    }

    final rgb = calloc.allocate<Uint8>(width * height * 3);

    _yuv420sp2rgbFunction(
      pixels,
      width,
      height,
      rgb,
    );

    final results = _copyUint8PointerToUint8List(rgb, width * height * 3);
    calloc
      ..free(pixels)
      ..free(rgb);
    return results;
  }

  /// Convert RGB to RGBA
  ///
  /// [rgb] is Image data in RGB format. [width] and [height] specify the width and height of the Image.
  /// Returns RGBA bytes.
  ///
  Uint8List rgb2rgba({
    required Uint8List rgb,
    required int width,
    required int height,
  }) {
    assert(width > 0, 'width is too small');
    assert(height > 0, 'height is too small');
    assert(rgb.isNotEmpty, 'pixels is empty');

    if (width <= 0 || height <= 0 || rgb.isEmpty) {
      return Uint8List(0);
    }

    final pixels = calloc.allocate<Uint8>(rgb.length);
    for (var i = 0; i < rgb.length; i++) {
      pixels[i] = rgb[i];
    }

    final rgba = calloc.allocate<Uint8>(width * height * 4);

    _rgb2rgbaFunction(
      pixels,
      width,
      height,
      rgba,
    );

    final results = _copyUint8PointerToUint8List(rgba, width * height * 4);
    calloc
      ..free(pixels)
      ..free(rgba);
    return results;
  }

  /// Rotate the pixel to match the orientation of the device.
  ///
  /// [pixels] is Image pixel data.
  /// [pixelChannel] is the number of channels of the image. For example, [PixelChannel.c3] for RGB or [PixelChannel.c4] for RGBA.
  /// [width] and [height] specify the width and height of the Image.
  /// [deviceOrientationType] is the orientation of the device.
  /// [sensorOrientation] is the orientation of the sensor.
  ///
  /// Returns [KannaRotateResults] with the rotated pixels data.
  ///
  KannaRotateResults kannaRotate({
    required Uint8List pixels,
    PixelChannel pixelChannel = PixelChannel.c3,
    required int width,
    required int height,
    KannaRotateDeviceOrientationType deviceOrientationType =
        KannaRotateDeviceOrientationType.portraitUp,
    int sensorOrientation = 90,
  }) {
    assert(width > 0, 'width is too small');
    assert(height > 0, 'height is too small');
    assert(pixels.isNotEmpty, 'pixels is empty');
    assert(sensorOrientation >= 0, 'sensorOrientation is too small');
    assert(sensorOrientation <= 360, 'sensorOrientation is too big');
    assert(sensorOrientation % 90 == 0, 'Only 0, 90, 180 or 270');

    if (width <= 0 ||
        height <= 0 ||
        pixels.isEmpty ||
        sensorOrientation < 0 ||
        sensorOrientation > 360 ||
        sensorOrientation % 90 != 0) {
      return const KannaRotateResults();
    }

    var rotateType = KannaRotateType.deg0;

    ///
    /// I don't know why you only need iOS but it works.
    /// Maybe related issue https://github.com/flutter/flutter/issues/94045
    ///
    switch (deviceOrientationType) {
      case KannaRotateDeviceOrientationType.portraitUp:
        rotateType = KannaRotateType.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (0 + sensorOrientation) % 360,
        );
        break;
      case KannaRotateDeviceOrientationType.landscapeRight:
        rotateType = KannaRotateType.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (90 + sensorOrientation) % 360,
        );
        break;
      case KannaRotateDeviceOrientationType.portraitDown:
        rotateType = KannaRotateType.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (180 + sensorOrientation) % 360,
        );
        break;
      case KannaRotateDeviceOrientationType.landscapeLeft:
        rotateType = KannaRotateType.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (270 + sensorOrientation) % 360,
        );
        break;
    }

    if (rotateType == KannaRotateType.deg0) {
      return KannaRotateResults(
        pixels: pixels,
        width: width,
        height: height,
        pixelChannel: pixelChannel,
      );
    }

    final src = calloc.allocate<Uint8>(pixels.length);
    for (var i = 0; i < pixels.length; i++) {
      src[i] = pixels[i];
    }
    final srcw = width;
    final srch = height;

    final dst = calloc.allocate<Uint8>(pixels.length);
    var dstw = width;
    var dsth = height;

    switch (rotateType) {
      case KannaRotateType.deg0:
      case KannaRotateType.deg180:
        break;
      case KannaRotateType.deg90:
      case KannaRotateType.deg270:
        dstw = height;
        dsth = width;
        break;
    }

    final type = rotateType.type;

    _kannaRotateFunction(
      src,
      pixelChannel.channelNum,
      srcw,
      srch,
      dst,
      dstw,
      dsth,
      type,
    );

    final results = _copyUint8PointerToUint8List(dst, pixels.length);
    calloc
      ..free(src)
      ..free(dst);

    return KannaRotateResults(
      pixels: results,
      width: dstw,
      height: dsth,
      pixelChannel: pixelChannel,
    );
  }

  /// Copy to Uint8List
  ///
  /// asTypedList is not used because pointer object cannot be free.
  /// https://api.flutter.dev/flutter/dart-ffi/Int8Pointer/asTypedList.html
  ///
  Uint8List _copyUint8PointerToUint8List(Pointer<Uint8> pointer, int length) {
    final result = Uint8List(length);
    for (var i = 0; i < length; i++) {
      result[i] = pointer[i];
    }
    return result;
  }
}
