import 'dart:typed_data';

import 'package:ncnn_yolox_flutter/models/models.dart';

class KannaRotateResults {
  KannaRotateResults(
    this.pixels,
    this.width,
    this.height,
    this.pixelChannel,
  );

  factory KannaRotateResults.empty() => KannaRotateResults(
        Uint8List(0),
        0,
        0,
        PixelChannel.c1,
      );

  late final Uint8List pixels;
  late final int width;
  late final int height;
  final PixelChannel pixelChannel;
}
