import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncnn_yolox_flutter/models/models.dart';

part 'kanna_rotate_results.freezed.dart';

@freezed
class KannaRotateResults with _$KannaRotateResults {
  const factory KannaRotateResults({
    Uint8List? pixels,
    @Default(0) int width,
    @Default(0) int height,
    @Default(PixelChannel.c1) PixelChannel pixelChannel,
  }) = _KannaRotateResults;
}
