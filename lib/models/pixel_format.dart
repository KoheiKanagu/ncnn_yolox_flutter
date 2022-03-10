// ignore_for_file: constant_identifier_names

enum PixelFormat {
  rgb,
  rgba,
  bgr,
  bgra,
}

extension PixelFormatExtension on PixelFormat {
  int get type {
    switch (this) {
      case PixelFormat.rgb:
        return _PIXEL_RGB2BGR;
      // return 131073;
      case PixelFormat.rgba:
        return _PIXEL_RGBA2BGR;
      // return 131076;
      case PixelFormat.bgr:
        return _PIXEL_BGR;
      // return 2;
      case PixelFormat.bgra:
        return _PIXEL_BGRA2BGR;
      // return 131077;
    }
  }
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
