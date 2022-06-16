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
            onTap: () async {
              final navigator = Navigator.of(context);

              final file =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (file != null) {
                await ref
                    .read(ncnnYoloxController.notifier)
                    .detectFromImageFile(file);

                await navigator.push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PreviewPage(),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('from camera image'),
            onTap: () async {
              final navigator = Navigator.of(context);

              final file =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (file != null) {
                await ref
                    .read(ncnnYoloxController.notifier)
                    .detectFromImageFile(file);

                await navigator.push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PreviewPage(),
                  ),
                );
              }
            },
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
}
