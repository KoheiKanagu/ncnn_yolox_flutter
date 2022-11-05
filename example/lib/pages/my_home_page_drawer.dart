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
        ],
      ),
    );
  }
}
