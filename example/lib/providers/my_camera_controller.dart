import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';
import 'package:ncnn_yolox_flutter_example/providers/ncnn_yolox_controller.dart';

final myCameraController = Provider(
  MyCameraController.new,
);

class MyCameraController {
  MyCameraController(this.ref);

  final Ref ref;

  CameraController? _cameraController;

  KannaRotateDeviceOrientationType get deviceOrientationType =>
      _cameraController?.value.deviceOrientation.kannaRotateType ??
      KannaRotateDeviceOrientationType.portraitUp;

  int get sensorOrientation =>
      _cameraController?.description.sensorOrientation ?? 90;

  bool _isProcessing = false;

  Future<void> startImageStream() async {
    await ref.read(ncnnYoloxController.notifier).initialize();

    final camera = (await availableCameras())[0];

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.startImageStream(
      (image) async {
        if (_isProcessing) {
          return;
        }

        _isProcessing = true;
        await ref
            .read(ncnnYoloxController.notifier)
            .detectFromCameraImage(image);
        _isProcessing = false;
      },
    );
  }

  Future<void> stopImageStream() async {
    final cameraValue = _cameraController?.value;
    if (cameraValue != null) {
      if (cameraValue.isInitialized && cameraValue.isStreamingImages) {
        await _cameraController?.stopImageStream();
        await _cameraController?.dispose();
        _cameraController = null;
      }
    }
  }
}

extension DeviceOrientationExtension on DeviceOrientation {
  KannaRotateDeviceOrientationType get kannaRotateType {
    switch (this) {
      case DeviceOrientation.portraitUp:
        return KannaRotateDeviceOrientationType.portraitUp;
      case DeviceOrientation.portraitDown:
        return KannaRotateDeviceOrientationType.portraitDown;
      case DeviceOrientation.landscapeLeft:
        return KannaRotateDeviceOrientationType.landscapeLeft;
      case DeviceOrientation.landscapeRight:
        return KannaRotateDeviceOrientationType.landscapeRight;
    }
  }
}
