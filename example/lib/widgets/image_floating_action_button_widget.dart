import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';

class ImageFloatingActionButtonWidget extends StatelessWidget {
  const ImageFloatingActionButtonWidget({
    Key? key,
    required this.imageSource,
    required this.ncnn,
    required this.onDetected,
  }) : super(key: key);

  final ImageSource imageSource;

  final NcnnYolox ncnn;

  final void Function(List<YoloxResults> results, ui.Image image) onDetected;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final image = await ImagePicker().pickImage(source: imageSource);
        if (image == null) {
          return;
        }

        final decodedImage = await decodeImageFromList(
          File(
            image.path,
          ).readAsBytesSync(),
        );

        final pixels = (await decodedImage.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!
            .buffer
            .asUint8List();

        final results = ncnn.detect(
          pixels: pixels,
          pixelFormat: PixelFormat.rgba,
          width: decodedImage.width,
          height: decodedImage.height,
        );

        onDetected(results, decodedImage);
      },
      child: Icon(
        imageSource == ImageSource.gallery
            ? Icons.photo_library
            : Icons.camera_alt,
      ),
    );
  }
}
