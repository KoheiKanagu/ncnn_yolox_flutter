import 'dart:async';
import 'dart:developer';
import 'dart:io';
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
    final completer = Completer<void>();
    final stopwatch = Stopwatch()..start();

    switch (cameraImage.format.group) {
      case ImageFormatGroup.unknown:
      case ImageFormatGroup.jpeg:
        log('not support format');
        return;
      case ImageFormatGroup.yuv420:
        state = _ncnnYolox
            .detectYUV420(
              y: cameraImage.planes[0].bytes,
              u: cameraImage.planes[1].bytes,
              v: cameraImage.planes[2].bytes,
              height: cameraImage.height,
              deviceOrientationType:
                  _read(myCameraController).deviceOrientationType,
              sensorOrientation: _read(myCameraController).sensorOrientation,
              onDecodeImage: (image) {
                _read(previewImage.state).state = image;
                completer.complete();
              },
            )
            .results;
        break;
      case ImageFormatGroup.bgra8888:
        state = _ncnnYolox
            .detectBGRA8888(
              pixels: cameraImage.planes[0].bytes,
              height: cameraImage.height,
              deviceOrientationType:
                  _read(myCameraController).deviceOrientationType,
              sensorOrientation: _read(myCameraController).sensorOrientation,
              onDecodeImage: (image) {
                _read(previewImage.state).state = image;
                completer.complete();
              },
            )
            .results;
        break;
    }

    stopwatch.stop();
    log('detect fps: ${1000 / stopwatch.elapsedMilliseconds}');

    return completer.future;
  }
}
