import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ncnn_yolox_flutter/models/models.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox.dart';

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

  Future<void> _initialize() async {
    await _ncnnYolox.initYolox(
      modelPath: 'assets/yolox/yolox.bin',
      paramPath: 'assets/yolox/yolox.param',
    );
  }

  Future<void> detectFromImageFile(XFile file) async {
    await _initialize();

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
}
