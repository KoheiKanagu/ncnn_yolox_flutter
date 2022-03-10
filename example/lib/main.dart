import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';
import 'package:ncnn_yolox_flutter_example/widgets/body_layout_builder_widget.dart';
import 'package:ncnn_yolox_flutter_example/widgets/image_floating_action_button_widget.dart';
import 'package:ncnn_yolox_flutter_example/widgets/image_stream_floating_action_button_widget.dart';

final ncnn = NcnnYolox();

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
  ui.Image? _previewImage;

  List<YoloxResults> _yoloxResults = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _setResultsState(
      List<YoloxResults> results,
      ui.Image image,
    ) {
      setState(() {
        _yoloxResults = results;
        _previewImage = image;
      });
    }

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ImageStreamFloatingActionButtonWidget(
            ncnn: ncnn,
            onDetected: _setResultsState,
          ),
          const SizedBox(height: 24),
          ImageFloatingActionButtonWidget(
            imageSource: ImageSource.camera,
            ncnn: ncnn,
            onDetected: _setResultsState,
          ),
          const SizedBox(height: 24),
          ImageFloatingActionButtonWidget(
            imageSource: ImageSource.gallery,
            ncnn: ncnn,
            onDetected: _setResultsState,
          ),
        ],
      ),
      body: BodyLayoutBuilderWidget(
        previewImage: _previewImage,
        results: _yoloxResults,
        labels: _labels,
      ),
    );
  }
}
