// ignore_for_file: prefer_single_quotes, avoid_private_typedef_functions, lines_longer_than_80_chars

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:ncnn_yolox_flutter/models/models.dart';
import 'package:path_provider/path_provider.dart';

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
);

typedef _DetectWithPixelsYolox = Pointer<Utf8> Function(
  Pointer<Uint8> pixels,
  int pixelFormat,
  int width,
  int height,
);

typedef _DetectWithImagePathYoloxNative = Pointer<Utf8> Function(
  Pointer<Utf8> imagePath,
);
typedef _DetectWithImagePathYolox = Pointer<Utf8> Function(
  Pointer<Utf8> imagePath,
);

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
  late _InitYolox _initYoloxFunction;

  /// Initialize YoloX
  /// Run it for the first time
  ///
  /// - [modelPath] - path to model file. like "assets/yolox.bin"
  /// - [paramPath] - path to parameter file. like "assets/yolox.param"
  Future<void> initYolox({
    required String modelPath,
    required String paramPath,
  }) async {
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

  /// Detect YoloX
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
  List<YoloxResults> detect({
    String? imagePath,
    Uint8List? pixels,
    PixelFormat pixelFormat = PixelFormat.rgb,
    int? width,
    int? height,
  }) {
    if (imagePath != null) {
      return _detectWithImagePath(
        imagePath: imagePath,
      );
    }

    if (width != null && height != null && pixels != null) {
      return _detectWithPixels(
        pixels: pixels,
        pixelFormat: pixelFormat,
        width: width,
        height: height,
      );
    }

    return [];
  }

  /// Reads an image from pixel data and executes Detect.
  ///
  /// [pixels] is pixel data of the image. [pixelFormat] is the pixel format.
  /// [width] and [height] are the width and height of the image.
  ///
  /// Returns a list of [YoloxResults]
  ///
  List<YoloxResults> _detectWithPixels({
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
      ).toDartString(),
    );
    calloc.free(pixelsNative);
    return results;
  }

  /// Read the image from the file path and execute Detect.
  ///
  /// The [imagePath] should be the path to the image, such as "assets/image.jpg".
  /// Returns the results of a YOLOX run as a List of [YoloxResults].
  ///
  List<YoloxResults> _detectWithImagePath({
    required String imagePath,
  }) {
    assert(imagePath.isNotEmpty, 'imagePath is empty');

    if (imagePath.isEmpty) {
      return [];
    }

    final imagePathNative = imagePath.toNativeUtf8();

    final results = YoloxResults.create(
      _detectWithImagePathYoloxFunction(
        imagePathNative,
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
      return KannaRotateResults.empty();
    }

    var rotateType = KannaRotateType.deg0;

    ///
    /// I don't know why you only need iOS but it works.
    /// Maybe related issue https://github.com/flutter/flutter/issues/94045
    ///
    switch (deviceOrientationType) {
      case KannaRotateDeviceOrientationType.portraitUp:
        rotateType = KananaRotateTypeExtension.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (0 + sensorOrientation) % 360,
        );
        break;
      case KannaRotateDeviceOrientationType.landscapeRight:
        rotateType = KananaRotateTypeExtension.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (90 + sensorOrientation) % 360,
        );
        break;
      case KannaRotateDeviceOrientationType.portraitDown:
        rotateType = KananaRotateTypeExtension.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (180 + sensorOrientation) % 360,
        );
        break;
      case KannaRotateDeviceOrientationType.landscapeLeft:
        rotateType = KananaRotateTypeExtension.fromDegree(
          Platform.isIOS
              ? (-90 + sensorOrientation) % 360
              : (270 + sensorOrientation) % 360,
        );
        break;
    }

    if (rotateType == KannaRotateType.deg0) {
      return KannaRotateResults(
        pixels,
        width,
        height,
        pixelChannel,
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
      results,
      dstw,
      dsth,
      pixelChannel,
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
