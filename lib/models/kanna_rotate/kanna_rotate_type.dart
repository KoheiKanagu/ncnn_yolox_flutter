enum KannaRotateType {
  deg0,
  deg90,
  deg180,
  deg270,
}

extension KananaRotateTypeExtension on KannaRotateType {
  // reference: https://github.com/Tencent/ncnn/blob/20220216/src/mat.h#L627-L637
  int get type {
    switch (this) {
      case KannaRotateType.deg0:
        return 1;
      case KannaRotateType.deg90:
        return 6;
      case KannaRotateType.deg180:
        return 3;
      case KannaRotateType.deg270:
        return 8;
    }
  }

  static KannaRotateType fromDegree(int degree) {
    switch (degree) {
      case 0:
        return KannaRotateType.deg0;
      case 90:
        return KannaRotateType.deg90;
      case 180:
        return KannaRotateType.deg180;
      case 270:
        return KannaRotateType.deg270;
      default:
        throw ArgumentError('not supported');
    }
  }
}
