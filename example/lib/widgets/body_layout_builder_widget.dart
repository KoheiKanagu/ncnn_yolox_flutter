import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';

class BodyLayoutBuilderWidget extends StatelessWidget {
  const BodyLayoutBuilderWidget({
    super.key,
    this.previewImage,
    required this.results,
    required this.labels,
  });

  final ui.Image? previewImage;

  final List<YoloxResults> results;

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (previewImage == null) {
          return const Center(
            child: Text('NO IMAGE'),
          );
        }

        final imageWidget = Expanded(
          flex: 2,
          child: FittedBox(
            child: SizedBox(
              width: previewImage!.width.toDouble(),
              height: previewImage!.height.toDouble(),
              child: CustomPaint(
                painter: YoloxResultsPainter(
                  image: previewImage!,
                  results: results,
                  labels: labels,
                ),
              ),
            ),
          ),
        );

        final listWidget = Expanded(
          child: ListView(
            children: results
                .map(
                  (e) => Text(
                    e.toString(),
                  ),
                )
                .toList(),
          ),
        );

        return Center(
          child: constraints.maxWidth < constraints.maxHeight
              ? Column(
                  children: [
                    imageWidget,
                    const SizedBox(height: 16),
                    listWidget,
                  ],
                )
              : Row(
                  children: [
                    imageWidget,
                    listWidget,
                  ],
                ),
        );
      },
    );
  }
}
