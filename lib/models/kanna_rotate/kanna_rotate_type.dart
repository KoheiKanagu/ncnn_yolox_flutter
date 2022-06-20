enum KannaRotateType {
  deg0(1),
  deg90(6),
  deg180(3),
  deg270(8),
  ;

  const KannaRotateType(this.type);

  // reference: https://github.com/Tencent/ncnn/blob/20220216/src/mat.h#L627-L637
  final int type;

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
