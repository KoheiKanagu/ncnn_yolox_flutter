import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ncnn_yolox_flutter_example/providers/my_camera_controller.dart';

class _AppLifecycleObserver extends NavigatorObserver
    with WidgetsBindingObserver {
  _AppLifecycleObserver({
    required this.onInactive,
  });

  final VoidCallback onInactive;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}

final appLifecycleObserver = Provider(
  (ref) {
    final observer = _AppLifecycleObserver(
      onInactive: () {
        ref.read(myCameraController).stopImageStream();
      },
    );

    WidgetsBinding.instance.addObserver(observer);
    ref.onDispose(
      () => WidgetsBinding.instance.removeObserver(observer),
    );

    return observer;
  },
);
