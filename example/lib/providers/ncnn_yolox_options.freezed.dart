// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ncnn_yolox_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NcnnYoloxOptions {
  bool get autoDispose => throw _privateConstructorUsedError;
  double get nmsThresh => throw _privateConstructorUsedError;
  double get confThresh => throw _privateConstructorUsedError;
  int get targetSize => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NcnnYoloxOptionsCopyWith<NcnnYoloxOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NcnnYoloxOptionsCopyWith<$Res> {
  factory $NcnnYoloxOptionsCopyWith(
          NcnnYoloxOptions value, $Res Function(NcnnYoloxOptions) then) =
      _$NcnnYoloxOptionsCopyWithImpl<$Res, NcnnYoloxOptions>;
  @useResult
  $Res call(
      {bool autoDispose, double nmsThresh, double confThresh, int targetSize});
}

/// @nodoc
class _$NcnnYoloxOptionsCopyWithImpl<$Res, $Val extends NcnnYoloxOptions>
    implements $NcnnYoloxOptionsCopyWith<$Res> {
  _$NcnnYoloxOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoDispose = null,
    Object? nmsThresh = null,
    Object? confThresh = null,
    Object? targetSize = null,
  }) {
    return _then(_value.copyWith(
      autoDispose: null == autoDispose
          ? _value.autoDispose
          : autoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
      nmsThresh: null == nmsThresh
          ? _value.nmsThresh
          : nmsThresh // ignore: cast_nullable_to_non_nullable
              as double,
      confThresh: null == confThresh
          ? _value.confThresh
          : confThresh // ignore: cast_nullable_to_non_nullable
              as double,
      targetSize: null == targetSize
          ? _value.targetSize
          : targetSize // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NcnnYoloxOptionsCopyWith<$Res>
    implements $NcnnYoloxOptionsCopyWith<$Res> {
  factory _$$_NcnnYoloxOptionsCopyWith(
          _$_NcnnYoloxOptions value, $Res Function(_$_NcnnYoloxOptions) then) =
      __$$_NcnnYoloxOptionsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool autoDispose, double nmsThresh, double confThresh, int targetSize});
}

/// @nodoc
class __$$_NcnnYoloxOptionsCopyWithImpl<$Res>
    extends _$NcnnYoloxOptionsCopyWithImpl<$Res, _$_NcnnYoloxOptions>
    implements _$$_NcnnYoloxOptionsCopyWith<$Res> {
  __$$_NcnnYoloxOptionsCopyWithImpl(
      _$_NcnnYoloxOptions _value, $Res Function(_$_NcnnYoloxOptions) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoDispose = null,
    Object? nmsThresh = null,
    Object? confThresh = null,
    Object? targetSize = null,
  }) {
    return _then(_$_NcnnYoloxOptions(
      autoDispose: null == autoDispose
          ? _value.autoDispose
          : autoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
      nmsThresh: null == nmsThresh
          ? _value.nmsThresh
          : nmsThresh // ignore: cast_nullable_to_non_nullable
              as double,
      confThresh: null == confThresh
          ? _value.confThresh
          : confThresh // ignore: cast_nullable_to_non_nullable
              as double,
      targetSize: null == targetSize
          ? _value.targetSize
          : targetSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_NcnnYoloxOptions implements _NcnnYoloxOptions {
  const _$_NcnnYoloxOptions(
      {this.autoDispose = true,
      this.nmsThresh = yoloxNmsThreshDefault,
      this.confThresh = yoloxConfThreshDefault,
      this.targetSize = yoloxTargetSizeDefault});

  @override
  @JsonKey()
  final bool autoDispose;
  @override
  @JsonKey()
  final double nmsThresh;
  @override
  @JsonKey()
  final double confThresh;
  @override
  @JsonKey()
  final int targetSize;

  @override
  String toString() {
    return 'NcnnYoloxOptions(autoDispose: $autoDispose, nmsThresh: $nmsThresh, confThresh: $confThresh, targetSize: $targetSize)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NcnnYoloxOptions &&
            (identical(other.autoDispose, autoDispose) ||
                other.autoDispose == autoDispose) &&
            (identical(other.nmsThresh, nmsThresh) ||
                other.nmsThresh == nmsThresh) &&
            (identical(other.confThresh, confThresh) ||
                other.confThresh == confThresh) &&
            (identical(other.targetSize, targetSize) ||
                other.targetSize == targetSize));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, autoDispose, nmsThresh, confThresh, targetSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NcnnYoloxOptionsCopyWith<_$_NcnnYoloxOptions> get copyWith =>
      __$$_NcnnYoloxOptionsCopyWithImpl<_$_NcnnYoloxOptions>(this, _$identity);
}

abstract class _NcnnYoloxOptions implements NcnnYoloxOptions {
  const factory _NcnnYoloxOptions(
      {final bool autoDispose,
      final double nmsThresh,
      final double confThresh,
      final int targetSize}) = _$_NcnnYoloxOptions;

  @override
  bool get autoDispose;
  @override
  double get nmsThresh;
  @override
  double get confThresh;
  @override
  int get targetSize;
  @override
  @JsonKey(ignore: true)
  _$$_NcnnYoloxOptionsCopyWith<_$_NcnnYoloxOptions> get copyWith =>
      throw _privateConstructorUsedError;
}
