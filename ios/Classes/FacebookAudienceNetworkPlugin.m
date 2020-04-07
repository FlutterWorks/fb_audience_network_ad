#import "FacebookAudienceNetworkPlugin.h"
#import <fb_audience_network_ad/fb_audience_network_ad-Swift.h>

@implementation FacebookAudienceNetworkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFacebookAudienceNetworkPlugin registerWithRegistrar:registrar];
}
@end
