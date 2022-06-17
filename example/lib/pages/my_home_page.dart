import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncnn_yolox_flutter_example/pages/preview_page.dart';
import 'package:ncnn_yolox_flutter_example/providers/my_camera_controller.dart';
import 'package:ncnn_yolox_flutter_example/providers/ncnn_yolox_controller.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('from gallery image'),
            onTap: () => _pickImage(
              context,
              ref.read,
              ImageSource.gallery,
            ),
          ),
          ListTile(
            title: const Text('from camera image'),
            onTap: () => _pickImage(
              context,
              ref.read,
              ImageSource.camera,
            ),
          ),
          ListTile(
            title: const Text('from camera stream'),
            onTap: () {
              ref.read(myCameraController).startImageStream();

              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PreviewPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    Reader read,
    ImageSource imageSource,
  ) async {
    final navigator = Navigator.of(context);

    final file = await ImagePicker().pickImage(source: imageSource);
    if (file != null) {
      final controller = read(ncnnYoloxController.notifier);
      await controller.initialize();
      await controller.detectFromImageFile(file);

      await navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => const PreviewPage(),
        ),
      );
    }
  }
}
