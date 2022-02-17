import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('ncnn_yolox_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await NcnnYoloxFlutter.platformVersion, '42');
  });
}
