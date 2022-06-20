// ignore_for_file: constant_identifier_names

enum PixelFormat {
  rgb(_PIXEL_RGB2BGR),
  rgba(_PIXEL_RGBA2BGR),
  bgr(_PIXEL_BGR),
  bgra(_PIXEL_BGRA2BGR),
  ;

  const PixelFormat(this.type);

  final int type;
}

/// YOLOX input must be BGR.
/// So we use a type that converts to BGR.
///
/// https://github.com/Tencent/ncnn/blob/20220216/src/mat.h#L219-L255
///
const _PIXEL_CONVERT_SHIFT = 16;

const _PIXEL_RGB = 1;
const _PIXEL_BGR = 2;
const _PIXEL_RGBA = 4;
const _PIXEL_BGRA = 5;

const _PIXEL_RGB2BGR = _PIXEL_RGB | (_PIXEL_BGR << _PIXEL_CONVERT_SHIFT);
const _PIXEL_RGBA2BGR = _PIXEL_RGBA | (_PIXEL_BGR << _PIXEL_CONVERT_SHIFT);
const _PIXEL_BGRA2BGR = _PIXEL_BGRA | (_PIXEL_BGR << _PIXEL_CONVERT_SHIFT);
