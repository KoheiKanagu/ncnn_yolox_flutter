// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'yolox_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$YoloxResults {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  int get label => throw _privateConstructorUsedError;
  double get prob => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $YoloxResultsCopyWith<YoloxResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YoloxResultsCopyWith<$Res> {
  factory $YoloxResultsCopyWith(
          YoloxResults value, $Res Function(YoloxResults) then) =
      _$YoloxResultsCopyWithImpl<$Res>;
  $Res call(
      {double x,
      double y,
      double width,
      double height,
      int label,
      double prob});
}

/// @nodoc
class _$YoloxResultsCopyWithImpl<$Res> implements $YoloxResultsCopyWith<$Res> {
  _$YoloxResultsCopyWithImpl(this._value, this._then);

  final YoloxResults _value;
  // ignore: unused_field
  final $Res Function(YoloxResults) _then;

  @override
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? label = freezed,
    Object? prob = freezed,
  }) {
    return _then(_value.copyWith(
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: width == freezed
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: height == freezed
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as int,
      prob: prob == freezed
          ? _value.prob
          : prob // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_YoloxResultsCopyWith<$Res>
    implements $YoloxResultsCopyWith<$Res> {
  factory _$$_YoloxResultsCopyWith(
          _$_YoloxResults value, $Res Function(_$_YoloxResults) then) =
      __$$_YoloxResultsCopyWithImpl<$Res>;
  @override
  $Res call(
      {double x,
      double y,
      double width,
      double height,
      int label,
      double prob});
}

/// @nodoc
class __$$_YoloxResultsCopyWithImpl<$Res>
    extends _$YoloxResultsCopyWithImpl<$Res>
    implements _$$_YoloxResultsCopyWith<$Res> {
  __$$_YoloxResultsCopyWithImpl(
      _$_YoloxResults _value, $Res Function(_$_YoloxResults) _then)
      : super(_value, (v) => _then(v as _$_YoloxResults));

  @override
  _$_YoloxResults get _value => super._value as _$_YoloxResults;

  @override
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? label = freezed,
    Object? prob = freezed,
  }) {
    return _then(_$_YoloxResults(
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: width == freezed
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: height == freezed
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as int,
      prob: prob == freezed
          ? _value.prob
          : prob // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_YoloxResults implements _YoloxResults {
  const _$_YoloxResults(
      {this.x = 0,
      this.y = 0,
      this.width = 0,
      this.height = 0,
      this.label = 0,
      this.prob = 0});

  @override
  @JsonKey()
  final double x;
  @override
  @JsonKey()
  final double y;
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final int label;
  @override
  @JsonKey()
  final double prob;

  @override
  String toString() {
    return 'YoloxResults(x: $x, y: $y, width: $width, height: $height, label: $label, prob: $prob)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_YoloxResults &&
            const DeepCollectionEquality().equals(other.x, x) &&
            const DeepCollectionEquality().equals(other.y, y) &&
            const DeepCollectionEquality().equals(other.width, width) &&
            const DeepCollectionEquality().equals(other.height, height) &&
            const DeepCollectionEquality().equals(other.label, label) &&
            const DeepCollectionEquality().equals(other.prob, prob));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(x),
      const DeepCollectionEquality().hash(y),
      const DeepCollectionEquality().hash(width),
      const DeepCollectionEquality().hash(height),
      const DeepCollectionEquality().hash(label),
      const DeepCollectionEquality().hash(prob));

  @JsonKey(ignore: true)
  @override
  _$$_YoloxResultsCopyWith<_$_YoloxResults> get copyWith =>
      __$$_YoloxResultsCopyWithImpl<_$_YoloxResults>(this, _$identity);
}

abstract class _YoloxResults implements YoloxResults {
  const factory _YoloxResults(
      {final double x,
      final double y,
      final double width,
      final double height,
      final int label,
      final double prob}) = _$_YoloxResults;

  @override
  double get x => throw _privateConstructorUsedError;
  @override
  double get y => throw _privateConstructorUsedError;
  @override
  double get width => throw _privateConstructorUsedError;
  @override
  double get height => throw _privateConstructorUsedError;
  @override
  int get label => throw _privateConstructorUsedError;
  @override
  double get prob => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_YoloxResultsCopyWith<_$_YoloxResults> get copyWith =>
      throw _privateConstructorUsedError;
}
