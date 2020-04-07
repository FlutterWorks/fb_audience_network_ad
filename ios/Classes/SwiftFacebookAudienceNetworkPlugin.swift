import Flutter
import UIKit

public class SwiftFacebookAudienceNetworkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        print("JIN Plugin register")
        
        registrar.register(
            SwiftFacebookAudienceNetworkBannerAdFactory(_registrar: registrar),
            withId: FbConstant.BANNER_AD_CHANNEL
        )

        registrar.register(
            SwiftFacebookAudienceNetworkNativeAdFactory(_registrar: registrar),
            withId: FbConstant.NATIVE_AD_CHANNEL
        )
        
        registrar.register(
            SwiftFacebookAudienceNetworkNativeBannerAdFactory(_registrar: registrar),
            withId: FbConstant.NATIVE_BANNER_AD_CHANNEL
        )
        
        let interstitialAdChannel: FlutterMethodChannel = FlutterMethodChannel.init(name: FbConstant.INTERSTITIAL_AD_CHANNEL, binaryMessenger: registrar.messenger())
        
        SwiftFacebookAudienceNetworkInterstitialAdPlugin.init(_channel: interstitialAdChannel)
    }
}
