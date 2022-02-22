// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';
import 'package:ncnn_yolox_flutter/yolox_results_painter.dart';

final ncnn = NcnnYoloxFlutter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ncnn.initYolox(
    modelPath: 'assets/yolox/yolox.bin',
    paramPath: 'assets/yolox/yolox.param',
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

ui.Image? _previewImage;

List<YoloxResults> _results = [];

final List<String> _labels = [
  'person',
  'bicycle',
  'car',
  'motorcycle',
  'airplane',
  'bus',
  'train',
  'truck',
  'boat',
  'traffic light',
  'fire hydrant',
  'stop sign',
  'parking meter',
  'bench',
  'bird',
  'cat',
  'dog',
  'horse',
  'sheep',
  'cow',
  'elephant',
  'bear',
  'zebra',
  'giraffe',
  'backpack',
  'umbrella',
  'handbag',
  'tie',
  'suitcase',
  'frisbee',
  'skis',
  'snowboard',
  'sports ball',
  'kite',
  'baseball bat',
  'baseball glove',
  'skateboard',
  'surfboard',
  'tennis racket',
  'bottle',
  'wine glass',
  'cup',
  'fork',
  'knife',
  'spoon',
  'bowl',
  'banana',
  'apple',
  'sandwich',
  'orange',
  'broccoli',
  'carrot',
  'hot dog',
  'pizza',
  'donut',
  'cake',
  'chair',
  'couch',
  'potted plant',
  'bed',
  'dining table',
  'toilet',
  'tv',
  'laptop',
  'mouse',
  'remote',
  'keyboard',
  'cell phone',
  'microwave',
  'oven',
  'toaster',
  'sink',
  'refrigerator',
  'book',
  'clock',
  'vase',
  'scissors',
  'teddy bear',
  'hair drier',
  'toothbrush'
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (image == null) {
            return;
          }

          _results = ncnn.detect(imagePath: image.path);

          final decodedImage = await decodeImageFromList(
            File(
              image.path,
            ).readAsBytesSync(),
          );

          setState(
            () {
              _previewImage = decodedImage;
            },
          );
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_previewImage == null) {
            return const Center(
              child: Text('NO IMAGE'),
            );
          }

          final imageWidget = Expanded(
            flex: 2,
            child: FittedBox(
              child: SizedBox(
                width: _previewImage!.width.toDouble(),
                height: _previewImage!.height.toDouble(),
                child: CustomPaint(
                  painter: YoloxResultsPainter(
                    image: _previewImage!,
                    results: _results,
                    labels: _labels,
                  ),
                ),
              ),
            ),
          );

          final listWidget = Expanded(
            child: ListView(
              children: _results
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
      ),
    );
  }
}
