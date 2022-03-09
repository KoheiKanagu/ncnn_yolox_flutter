import 'dart:typed_data';

class KannaRotateResults {
  KannaRotateResults(
    this.rgb,
    this.width,
    this.height,
  );

  factory KannaRotateResults.empty() => KannaRotateResults(Uint8List(0), 0, 0);

  late final Uint8List rgb;
  late final int width;
  late final int height;
}
