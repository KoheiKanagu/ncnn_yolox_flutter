import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'ncnn_yolox_options.freezed.dart';

@freezed
class NcnnYoloxOptions with _$NcnnYoloxOptions {
  const factory NcnnYoloxOptions({
    @Default(true) bool autoDispose,
  }) = _NcnnYoloxOptions;
}

final ncnnYoloxOptions = StateProvider(
  (ref) => const NcnnYoloxOptions(),
  name: 'ncnnYoloxOptions',
);
