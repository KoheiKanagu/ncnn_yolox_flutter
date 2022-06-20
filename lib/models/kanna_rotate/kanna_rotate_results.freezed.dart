// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'kanna_rotate_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$KannaRotateResults {
  Uint8List? get pixels => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  PixelChannel get pixelChannel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $KannaRotateResultsCopyWith<KannaRotateResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KannaRotateResultsCopyWith<$Res> {
  factory $KannaRotateResultsCopyWith(
          KannaRotateResults value, $Res Function(KannaRotateResults) then) =
      _$KannaRotateResultsCopyWithImpl<$Res>;
  $Res call(
      {Uint8List? pixels, int width, int height, PixelChannel pixelChannel});
}

/// @nodoc
class _$KannaRotateResultsCopyWithImpl<$Res>
    implements $KannaRotateResultsCopyWith<$Res> {
  _$KannaRotateResultsCopyWithImpl(this._value, this._then);

  final KannaRotateResults _value;
  // ignore: unused_field
  final $Res Function(KannaRotateResults) _then;

  @override
  $Res call({
    Object? pixels = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? pixelChannel = freezed,
  }) {
    return _then(_value.copyWith(
      pixels: pixels == freezed
          ? _value.pixels
          : pixels // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      width: width == freezed
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: height == freezed
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      pixelChannel: pixelChannel == freezed
          ? _value.pixelChannel
          : pixelChannel // ignore: cast_nullable_to_non_nullable
              as PixelChannel,
    ));
  }
}

/// @nodoc
abstract class _$$_KannaRotateResultsCopyWith<$Res>
    implements $KannaRotateResultsCopyWith<$Res> {
  factory _$$_KannaRotateResultsCopyWith(_$_KannaRotateResults value,
          $Res Function(_$_KannaRotateResults) then) =
      __$$_KannaRotateResultsCopyWithImpl<$Res>;
  @override
  $Res call(
      {Uint8List? pixels, int width, int height, PixelChannel pixelChannel});
}

/// @nodoc
class __$$_KannaRotateResultsCopyWithImpl<$Res>
    extends _$KannaRotateResultsCopyWithImpl<$Res>
    implements _$$_KannaRotateResultsCopyWith<$Res> {
  __$$_KannaRotateResultsCopyWithImpl(
      _$_KannaRotateResults _value, $Res Function(_$_KannaRotateResults) _then)
      : super(_value, (v) => _then(v as _$_KannaRotateResults));

  @override
  _$_KannaRotateResults get _value => super._value as _$_KannaRotateResults;

  @override
  $Res call({
    Object? pixels = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? pixelChannel = freezed,
  }) {
    return _then(_$_KannaRotateResults(
      pixels: pixels == freezed
          ? _value.pixels
          : pixels // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      width: width == freezed
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: height == freezed
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      pixelChannel: pixelChannel == freezed
          ? _value.pixelChannel
          : pixelChannel // ignore: cast_nullable_to_non_nullable
              as PixelChannel,
    ));
  }
}

/// @nodoc

class _$_KannaRotateResults implements _KannaRotateResults {
  const _$_KannaRotateResults(
      {this.pixels,
      this.width = 0,
      this.height = 0,
      this.pixelChannel = PixelChannel.c1});

  @override
  final Uint8List? pixels;
  @override
  @JsonKey()
  final int width;
  @override
  @JsonKey()
  final int height;
  @override
  @JsonKey()
  final PixelChannel pixelChannel;

  @override
  String toString() {
    return 'KannaRotateResults(pixels: $pixels, width: $width, height: $height, pixelChannel: $pixelChannel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_KannaRotateResults &&
            const DeepCollectionEquality().equals(other.pixels, pixels) &&
            const DeepCollectionEquality().equals(other.width, width) &&
            const DeepCollectionEquality().equals(other.height, height) &&
            const DeepCollectionEquality()
                .equals(other.pixelChannel, pixelChannel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(pixels),
      const DeepCollectionEquality().hash(width),
      const DeepCollectionEquality().hash(height),
      const DeepCollectionEquality().hash(pixelChannel));

  @JsonKey(ignore: true)
  @override
  _$$_KannaRotateResultsCopyWith<_$_KannaRotateResults> get copyWith =>
      __$$_KannaRotateResultsCopyWithImpl<_$_KannaRotateResults>(
          this, _$identity);
}

abstract class _KannaRotateResults implements KannaRotateResults {
  const factory _KannaRotateResults(
      {final Uint8List? pixels,
      final int width,
      final int height,
      final PixelChannel pixelChannel}) = _$_KannaRotateResults;

  @override
  Uint8List? get pixels => throw _privateConstructorUsedError;
  @override
  int get width => throw _privateConstructorUsedError;
  @override
  int get height => throw _privateConstructorUsedError;
  @override
  PixelChannel get pixelChannel => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_KannaRotateResultsCopyWith<_$_KannaRotateResults> get copyWith =>
      throw _privateConstructorUsedError;
}
