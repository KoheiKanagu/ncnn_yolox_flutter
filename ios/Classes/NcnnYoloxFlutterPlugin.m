#import "NcnnYoloxFlutterPlugin.h"
#if __has_include(<ncnn_yolox_flutter/ncnn_yolox_flutter-Swift.h>)
#import <ncnn_yolox_flutter/ncnn_yolox_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ncnn_yolox_flutter-Swift.h"
#endif

@implementation NcnnYoloxFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNcnnYoloxFlutterPlugin registerWithRegistrar:registrar];
}
@end
