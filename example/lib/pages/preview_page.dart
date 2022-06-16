import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';
import 'package:ncnn_yolox_flutter_example/main.dart';
import 'package:ncnn_yolox_flutter_example/providers/my_camera_controller.dart';
import 'package:ncnn_yolox_flutter_example/providers/ncnn_yolox_controller.dart';

class PreviewPage extends HookConsumerWidget {
  const PreviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewImage = ref.watch(NcnnYoloxController.previewImage);

    return WillPopScope(
      onWillPop: () async {
        await ref.read(myCameraController).stopImageStream();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: previewImage == null
                ? const Text('No preview image')
                : FittedBox(
                    child: SizedBox(
                      width: previewImage.width.toDouble(),
                      height: previewImage.height.toDouble(),
                      child: CustomPaint(
                        painter: YoloxResultsPainter(
                          image: previewImage,
                          results: ref.watch(ncnnYoloxController),
                          labels: cocoLabels,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
