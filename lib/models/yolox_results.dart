// ignore_for_file: lines_longer_than_80_chars

class YoloxResults {
  YoloxResults(
    this.x,
    this.y,
    this.width,
    this.height,
    this.label,
    this.prob,
  );

  final double x;
  final double y;
  final double width;
  final double height;
  final int label;
  final double prob;

  static List<YoloxResults> create(String response) => response
          .split('\n')
          .where(
            (element) => element.isNotEmpty,
          )
          .map(
        (e) {
          final values = e.split(',');
          return YoloxResults(
            double.parse(values[0]),
            double.parse(values[1]),
            double.parse(values[2]),
            double.parse(values[3]),
            int.parse(values[4]),
            double.parse(values[5]),
          );
        },
      ).toList();

  @override
  String toString() =>
      'YoloxResults{x: $x, y: $y, width: $width, height: $height, label: $label, prob: $prob}';
}
