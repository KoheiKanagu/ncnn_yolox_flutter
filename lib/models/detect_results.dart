import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncnn_yolox_flutter/models/models.dart';

part 'detect_results.freezed.dart';

@freezed
class DetectResults with _$DetectResults {
  const factory DetectResults({
    @Default(<YoloxResults>[]) List<YoloxResults> results,
    KannaRotateResults? image,
  }) = _DetectResults;
}
