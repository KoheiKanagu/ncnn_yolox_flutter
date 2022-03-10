import 'dart:typed_data';

class KannaRotateResults {
  KannaRotateResults(
    this.pixels,
    this.width,
    this.height,
  );

  factory KannaRotateResults.empty() => KannaRotateResults(Uint8List(0), 0, 0);

  late final Uint8List pixels;
  late final int width;
  late final int height;
}
