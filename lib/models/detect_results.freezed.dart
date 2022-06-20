// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'detect_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DetectResults {
  List<YoloxResults> get results => throw _privateConstructorUsedError;
  KannaRotateResults? get image => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DetectResultsCopyWith<DetectResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetectResultsCopyWith<$Res> {
  factory $DetectResultsCopyWith(
          DetectResults value, $Res Function(DetectResults) then) =
      _$DetectResultsCopyWithImpl<$Res>;
  $Res call({List<YoloxResults> results, KannaRotateResults? image});

  $KannaRotateResultsCopyWith<$Res>? get image;
}

/// @nodoc
class _$DetectResultsCopyWithImpl<$Res>
    implements $DetectResultsCopyWith<$Res> {
  _$DetectResultsCopyWithImpl(this._value, this._then);

  final DetectResults _value;
  // ignore: unused_field
  final $Res Function(DetectResults) _then;

  @override
  $Res call({
    Object? results = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      results: results == freezed
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<YoloxResults>,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as KannaRotateResults?,
    ));
  }

  @override
  $KannaRotateResultsCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $KannaRotateResultsCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value));
    });
  }
}

/// @nodoc
abstract class _$$_DetectResultsCopyWith<$Res>
    implements $DetectResultsCopyWith<$Res> {
  factory _$$_DetectResultsCopyWith(
          _$_DetectResults value, $Res Function(_$_DetectResults) then) =
      __$$_DetectResultsCopyWithImpl<$Res>;
  @override
  $Res call({List<YoloxResults> results, KannaRotateResults? image});

  @override
  $KannaRotateResultsCopyWith<$Res>? get image;
}

/// @nodoc
class __$$_DetectResultsCopyWithImpl<$Res>
    extends _$DetectResultsCopyWithImpl<$Res>
    implements _$$_DetectResultsCopyWith<$Res> {
  __$$_DetectResultsCopyWithImpl(
      _$_DetectResults _value, $Res Function(_$_DetectResults) _then)
      : super(_value, (v) => _then(v as _$_DetectResults));

  @override
  _$_DetectResults get _value => super._value as _$_DetectResults;

  @override
  $Res call({
    Object? results = freezed,
    Object? image = freezed,
  }) {
    return _then(_$_DetectResults(
      results: results == freezed
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<YoloxResults>,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as KannaRotateResults?,
    ));
  }
}

/// @nodoc

class _$_DetectResults implements _DetectResults {
  const _$_DetectResults(
      {final List<YoloxResults> results = const <YoloxResults>[], this.image})
      : _results = results;

  final List<YoloxResults> _results;
  @override
  @JsonKey()
  List<YoloxResults> get results {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final KannaRotateResults? image;

  @override
  String toString() {
    return 'DetectResults(results: $results, image: $image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DetectResults &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_results),
      const DeepCollectionEquality().hash(image));

  @JsonKey(ignore: true)
  @override
  _$$_DetectResultsCopyWith<_$_DetectResults> get copyWith =>
      __$$_DetectResultsCopyWithImpl<_$_DetectResults>(this, _$identity);
}

abstract class _DetectResults implements DetectResults {
  const factory _DetectResults(
      {final List<YoloxResults> results,
      final KannaRotateResults? image}) = _$_DetectResults;

  @override
  List<YoloxResults> get results => throw _privateConstructorUsedError;
  @override
  KannaRotateResults? get image => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DetectResultsCopyWith<_$_DetectResults> get copyWith =>
      throw _privateConstructorUsedError;
}
