import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox.dart';

part 'ncnn_yolox_options.freezed.dart';

@freezed
class NcnnYoloxOptions with _$NcnnYoloxOptions {
  const factory NcnnYoloxOptions({
    @Default(true) bool autoDispose,
    @Default(yoloxNmsThreshDefault) double nmsThresh,
    @Default(yoloxConfThreshDefault) double confThresh,
    @Default(yoloxTargetSizeDefault) int targetSize,
  }) = _NcnnYoloxOptions;
}

final ncnnYoloxOptions = StateProvider(
  (ref) => const NcnnYoloxOptions(),
  name: 'ncnnYoloxOptions',
);
