#import "PaytmFlutterPlugin.h"
#if __has_include(<paytm_flutter/paytm_flutter-Swift.h>)
#import <paytm_flutter/paytm_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "paytm_flutter-Swift.h"
#endif

@implementation PaytmFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPaytmFlutterPlugin registerWithRegistrar:registrar];
}
@end
