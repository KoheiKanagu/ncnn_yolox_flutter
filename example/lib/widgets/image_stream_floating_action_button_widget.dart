// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';

class ImageStreamFloatingActionButtonWidget extends StatefulWidget {
  const ImageStreamFloatingActionButtonWidget({
    Key? key,
    required this.ncnn,
    required this.onDetected,
  }) : super(key: key);

  final NcnnYolox ncnn;

  final void Function(
    List<YoloxResults> results,
    ui.Image image,
  ) onDetected;

  @override
  State<ImageStreamFloatingActionButtonWidget> createState() =>
      _VideoStreamFloatingActionButtonState();
}

class _VideoStreamFloatingActionButtonState
    extends State<ImageStreamFloatingActionButtonWidget>
    with WidgetsBindingObserver {
  bool isCameraStream = false;

  bool processing = false;

  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    cameraController?.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        cameraController?.dispose();
        setState(() {
          isCameraStream = false;
        });
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        isCameraStream
            ? await cameraController?.stopImageStream()
            : await _startImageStream();

        setState(() {
          isCameraStream = !isCameraStream;
        });
      },
      child: isCameraStream
          ? const Icon(Icons.stop)
          : const Icon(Icons.play_arrow),
    );
  }

  Future<void> _startImageStream() async {
    final camera = (await availableCameras())[0];

    cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await cameraController!.initialize();
    await cameraController!.startImageStream(
      (image) {
        if (processing) {
          return;
        }

        switch (image.format.group) {
          case ImageFormatGroup.unknown:
          case ImageFormatGroup.jpeg:
            print('not support format');
            return;
          case ImageFormatGroup.yuv420:
            _yuv420(image);
            break;
          case ImageFormatGroup.bgra8888:
            _bgra(image);
            break;
        }
      },
    );
  }

  void _yuv420(CameraImage image) {
    processing = true;

    final stopwatchYuv420sp2Uint8List = Stopwatch()..start();
    final yuv420sp = widget.ncnn.yuv420sp2Uint8List(
      y: image.planes[0].bytes,
      u: image.planes[1].bytes,
      v: image.planes[2].bytes,
    );
    stopwatchYuv420sp2Uint8List.stop();

    final stopwatchYuv420sp2rgb = Stopwatch()..start();
    final pixels = widget.ncnn.yuv420sp2rgb(
      yuv420sp: yuv420sp,
      width: image.width,
      height: image.height,
    );
    stopwatchYuv420sp2rgb.stop();

    final deviceOrientationType =
        cameraController!.value.deviceOrientation.kannaRotateType;
    final sensorOrientation = cameraController!.description.sensorOrientation;

    final stopwatchKannaRotate = Stopwatch()..start();
    final rotated = widget.ncnn.kannaRotate(
      pixels: pixels,
      pixelChannel: PixelChannel.c3,
      width: image.width,
      height: image.height,
      deviceOrientationType: deviceOrientationType,
      sensorOrientation: sensorOrientation,
    );
    stopwatchKannaRotate.stop();

    final stopwatchRgb2rgba = Stopwatch()..start();
    final rgba = widget.ncnn.rgb2rgba(
      rgb: rotated.pixels,
      width: rotated.width,
      height: rotated.height,
    );
    stopwatchRgb2rgba.stop();

    final stopwatchDetect = Stopwatch()..start();
    final results = widget.ncnn.detect(
      pixels: rotated.pixels,
      pixelFormat: PixelFormat.rgb,
      width: rotated.width,
      height: rotated.height,
    );
    stopwatchDetect.stop();

    final stopwatchDecodeImageFromPixels = Stopwatch()..start();
    ui.decodeImageFromPixels(
      rgba,
      rotated.width,
      rotated.height,
      ui.PixelFormat.rgba8888,
      (resultsImg) async {
        stopwatchDecodeImageFromPixels.stop();

        widget.onDetected(results, resultsImg);
        processing = false;

        final sumMs = stopwatchYuv420sp2Uint8List.elapsedMilliseconds +
            stopwatchYuv420sp2rgb.elapsedMilliseconds +
            stopwatchKannaRotate.elapsedMilliseconds +
            stopwatchRgb2rgba.elapsedMilliseconds +
            stopwatchDetect.elapsedMilliseconds +
            stopwatchDecodeImageFromPixels.elapsedMilliseconds;
        print(
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
      },
    );
  }

  void _bgra(CameraImage image) {
    processing = true;

    final deviceOrientationType =
        cameraController!.value.deviceOrientation.kannaRotateType;
    final sensorOrientation = cameraController!.description.sensorOrientation;

    final stopwatchKannaRotate = Stopwatch()..start();
    final rotated = widget.ncnn.kannaRotate(
      pixels: image.planes[0].bytes,
      pixelChannel: PixelChannel.c4,
      width: image.width,
      height: image.height,
      deviceOrientationType: deviceOrientationType,
      sensorOrientation: sensorOrientation,
    );
    stopwatchKannaRotate.stop();

    final stopwatchDetect = Stopwatch()..start();
    final results = widget.ncnn.detect(
      pixels: rotated.pixels,
      pixelFormat: PixelFormat.bgra,
      width: rotated.width,
      height: rotated.height,
    );
    stopwatchDetect.stop();

    final stopwatchDecodeImageFromPixels = Stopwatch()..start();
    ui.decodeImageFromPixels(
      rotated.pixels,
      rotated.width,
      rotated.height,
      ui.PixelFormat.bgra8888,
      (resultsImg) async {
        stopwatchDecodeImageFromPixels.stop();

        widget.onDetected(results, resultsImg);
        processing = false;

        final sumMs = stopwatchKannaRotate.elapsedMilliseconds +
            stopwatchDetect.elapsedMilliseconds +
            stopwatchDecodeImageFromPixels.elapsedMilliseconds;

        print(
          '''====
kannaRotate: ${stopwatchKannaRotate.elapsedMilliseconds}ms
detect: ${stopwatchDetect.elapsedMilliseconds}ms
decodeImageFromPixels: ${stopwatchDecodeImageFromPixels.elapsedMilliseconds}ms

FPS: ${1000 / sumMs}
====
''',
        );
      },
    );
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
        return KannaRotateDeviceOrientationType.landscapeRight;
      case DeviceOrientation.landscapeRight:
        return KannaRotateDeviceOrientationType.landscapeLeft;
    }
  }
}
