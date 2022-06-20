import 'package:freezed_annotation/freezed_annotation.dart';

part 'yolox_results.freezed.dart';

@freezed
class YoloxResults with _$YoloxResults {
  const factory YoloxResults({
    @Default(0) double x,
    @Default(0) double y,
    @Default(0) double width,
    @Default(0) double height,
    @Default(0) int label,
    @Default(0) double prob,
  }) = _YoloxResults;

  static List<YoloxResults> create(String response) => response
          .split('\n')
          .where(
            (element) => element.isNotEmpty,
          )
          .map(
        (e) {
          final values = e.split(',');
          return YoloxResults(
            x: double.parse(values[0]),
            y: double.parse(values[1]),
            width: double.parse(values[2]),
            height: double.parse(values[3]),
            label: int.parse(values[4]),
            prob: double.parse(values[5]),
          );
        },
      ).toList();
}
