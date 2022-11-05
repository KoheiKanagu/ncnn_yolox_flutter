import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ncnn_yolox_flutter_example/providers/ncnn_yolox_options.dart';

class MyHomePageDrawer extends HookConsumerWidget {
  const MyHomePageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          SwitchListTile.adaptive(
            title: const Text('autoDispose'),
            subtitle: const Text(
              // ignore: lines_longer_than_80_chars
              'If true, multiple calls to initYolox will automatically dispose of previous models.',
            ),
            value: ref.watch(ncnnYoloxOptions).autoDispose,
            onChanged: (value) {
              ref.read(ncnnYoloxOptions.notifier).state =
                  ref.read(ncnnYoloxOptions).copyWith(
                        autoDispose: value,
                      );
            },
          ),
          ListTile(
            title: const Text('nmsThresh'),
            subtitle: const Text('NMS threshold.'),
            trailing: Text(ref.watch(ncnnYoloxOptions).nmsThresh.toString()),
            onTap: () async {
              final results = await showTextInputDialog(
                context: context,
                title: 'nmsThresh',
                textFields: [
                  const DialogTextField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
              );

              ref.read(ncnnYoloxOptions.notifier).state =
                  ref.read(ncnnYoloxOptions).copyWith(
                        nmsThresh: double.parse(results!.first),
                      );
            },
          ),
          ListTile(
            title: const Text('confThresh'),
            subtitle: const Text('Threshold of bounding box prob.'),
            trailing: Text(ref.watch(ncnnYoloxOptions).confThresh.toString()),
            onTap: () async {
              final results = await showTextInputDialog(
                context: context,
                title: 'confThresh',
                textFields: [
                  const DialogTextField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
              );

              ref.read(ncnnYoloxOptions.notifier).state =
                  ref.read(ncnnYoloxOptions).copyWith(
                        confThresh: double.parse(results!.first),
                      );
            },
          ),
          ListTile(
            title: const Text('targetSize'),
            subtitle: const Text(
              'Target image size after resize, might use 416 for small model.',
            ),
            trailing: Text(ref.watch(ncnnYoloxOptions).targetSize.toString()),
            onTap: () async {
              final results = await showTextInputDialog(
                context: context,
                title: 'targetSize',
                textFields: [
                  const DialogTextField(
                    keyboardType: TextInputType.number,
                  ),
                ],
              );

              ref.read(ncnnYoloxOptions.notifier).state =
                  ref.read(ncnnYoloxOptions).copyWith(
                        targetSize: int.parse(results!.first),
                      );
            },
          )
        ],
      ),
    );
  }
}
