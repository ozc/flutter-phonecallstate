#import "PhonecallstatePlugin.h"
#import <phonecallstate/phonecallstate-Swift.h>

@implementation PhonecallstatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhonecallstatePlugin registerWithRegistrar:registrar];
}
@end
