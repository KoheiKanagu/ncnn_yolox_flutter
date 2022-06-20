import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ncnn_yolox_flutter/models/models.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox.dart';
import 'package:ncnn_yolox_flutter_example/providers/my_camera_controller.dart';

final ncnnYoloxController =
    StateNotifierProvider<NcnnYoloxController, List<YoloxResults>>(
  (ref) => NcnnYoloxController(ref.read),
);

class NcnnYoloxController extends StateNotifier<List<YoloxResults>> {
  NcnnYoloxController(this._read) : super([]);

  final Reader _read;

  final _ncnnYolox = NcnnYolox();

  static final previewImage = StateProvider<ui.Image?>(
    (_) => null,
  );

  Future<void> initialize() async {
    await _ncnnYolox.initYolox(
      modelPath: 'assets/yolox/yolox.bin',
      paramPath: 'assets/yolox/yolox.param',
    );
  }

  Future<void> detectFromImageFile(XFile file) async {
    final decodedImage = await decodeImageFromList(
      File(
        file.path,
      ).readAsBytesSync(),
    );

    final pixels = (await decodedImage.toByteData())!.buffer.asUint8List();
    state = _ncnnYolox.detect(
      pixels: pixels,
      pixelFormat: PixelFormat.rgba,
      width: decodedImage.width,
      height: decodedImage.height,
    );
    log(state.toString());

    _read(previewImage.state).state = decodedImage;
  }

  Future<void> detectFromCameraImage(CameraImage cameraImage) async {
    switch (cameraImage.format.group) {
      case ImageFormatGroup.unknown:
      case ImageFormatGroup.jpeg:
        log('not support format');
        return;
      case ImageFormatGroup.yuv420:
        await _yuv420(
          cameraImage,
          _read(myCameraController).deviceOrientationType,
          _read(myCameraController).sensorOrientation,
        );
        break;
      case ImageFormatGroup.bgra8888:
        await _bgra(
          cameraImage,
          _read(myCameraController).deviceOrientationType,
          _read(myCameraController).sensorOrientation,
        );
        break;
    }
  }

  Future<void> _bgra(
    CameraImage cameraImage,
    KannaRotateDeviceOrientationType deviceOrientationType,
    int sensorOrientation,
  ) async {
    final stopwatchKannaRotate = Stopwatch()..start();
    final rotated = _ncnnYolox.kannaRotate(
      pixels: cameraImage.planes[0].bytes,
      pixelChannel: PixelChannel.c4,
      width: cameraImage.width,
      height: cameraImage.height,
      deviceOrientationType: deviceOrientationType,
      sensorOrientation: sensorOrientation,
    );
    stopwatchKannaRotate.stop();

    final stopwatchDetect = Stopwatch()..start();
    state = _ncnnYolox.detect(
      pixels: rotated.pixels,
      pixelFormat: PixelFormat.bgra,
      width: rotated.width,
      height: rotated.height,
    );
    stopwatchDetect.stop();

    final completer = Completer<void>();

    final stopwatchDecodeImageFromPixels = Stopwatch()..start();
    ui.decodeImageFromPixels(
      rotated.pixels ?? Uint8List(0),
      rotated.width,
      rotated.height,
      ui.PixelFormat.bgra8888,
      (resultsImg) async {
        stopwatchDecodeImageFromPixels.stop();

        final sumMs = stopwatchKannaRotate.elapsedMilliseconds +
            stopwatchDetect.elapsedMilliseconds +
            stopwatchDecodeImageFromPixels.elapsedMilliseconds;

        log(
          '''====
kannaRotate: ${stopwatchKannaRotate.elapsedMilliseconds}ms
detect: ${stopwatchDetect.elapsedMilliseconds}ms
decodeImageFromPixels: ${stopwatchDecodeImageFromPixels.elapsedMilliseconds}ms

FPS: ${1000 / sumMs}
====
''',
        );

        _read(previewImage.state).state = resultsImg;
        completer.complete();
      },
    );

    return completer.future;
  }

  Future<void> _yuv420(
    CameraImage cameraImage,
    KannaRotateDeviceOrientationType deviceOrientationType,
    int sensorOrientation,
  ) async {
    final stopwatchYuv420sp2Uint8List = Stopwatch()..start();
    final yuv420sp = _ncnnYolox.yuv420sp2Uint8List(
      y: cameraImage.planes[0].bytes,
      u: cameraImage.planes[1].bytes,
      v: cameraImage.planes[2].bytes,
    );
    stopwatchYuv420sp2Uint8List.stop();

    final stopwatchYuv420sp2rgb = Stopwatch()..start();
    final pixels = _ncnnYolox.yuv420sp2rgb(
      yuv420sp: yuv420sp,
      width: cameraImage.width,
      height: cameraImage.height,
    );
    stopwatchYuv420sp2rgb.stop();

    final stopwatchKannaRotate = Stopwatch()..start();
    final rotated = _ncnnYolox.kannaRotate(
      pixels: pixels,
      width: cameraImage.width,
      height: cameraImage.height,
      deviceOrientationType: deviceOrientationType,
      sensorOrientation: sensorOrientation,
    );
    stopwatchKannaRotate.stop();

    final stopwatchRgb2rgba = Stopwatch()..start();
    final rgba = _ncnnYolox.rgb2rgba(
      rgb: rotated.pixels ?? Uint8List(0),
      width: rotated.width,
      height: rotated.height,
    );
    stopwatchRgb2rgba.stop();

    final stopwatchDetect = Stopwatch()..start();
    state = _ncnnYolox.detect(
      pixels: rotated.pixels,
      width: rotated.width,
      height: rotated.height,
    );
    stopwatchDetect.stop();

    final completer = Completer<void>();

    final stopwatchDecodeImageFromPixels = Stopwatch()..start();
    ui.decodeImageFromPixels(
      rgba,
      rotated.width,
      rotated.height,
      ui.PixelFormat.rgba8888,
      (resultsImg) async {
        stopwatchDecodeImageFromPixels.stop();

        final sumMs = stopwatchYuv420sp2Uint8List.elapsedMilliseconds +
            stopwatchYuv420sp2rgb.elapsedMilliseconds +
            stopwatchKannaRotate.elapsedMilliseconds +
            stopwatchRgb2rgba.elapsedMilliseconds +
            stopwatchDetect.elapsedMilliseconds +
            stopwatchDecodeImageFromPixels.elapsedMilliseconds;
        log(
          '''====
yuv420sp2Uint8List: ${stopwatchYuv420sp2Uint8List.elapsedMilliseconds}ms
yuv420sp2rgb: ${stopwatchYuv420sp2rgb.elapsedMilliseconds}ms
kannaRotate: ${stopwatchKannaRotate.elapsedMilliseconds}ms
rgb2rgba: ${stopwatchRgb2rgba.elapsedMilliseconds}ms
detect: ${stopwatchDetect.elapsedMilliseconds}ms
decodeImageFromPixels: ${stopwatchDecodeImageFromPixels.elapsedMilliseconds}ms

FPS: ${1000 / sumMs}
====
''',
        );

        _read(previewImage.state).state = resultsImg;
        completer.complete();
      },
    );

    return completer.future;
  }
}
