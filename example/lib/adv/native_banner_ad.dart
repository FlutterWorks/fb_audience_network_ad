import 'package:fb_audience_network_ad/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../common/fb_constants.dart';

class NativeAdBannerWidget extends StatefulWidget {
  @override
  _NativeAdBannerWidgetState createState() => _NativeAdBannerWidgetState();
}

class _NativeAdBannerWidgetState extends State<NativeAdBannerWidget> {

  NativeAdResult _nativeAdResult;

  String getPlacementId() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return ANDROID_AD_NATIVE_BANNER_PLACEMENT_ID;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return IOS_AD_NATIVE_BANNER_PLACEMENT_ID;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: FacebookNativeAd(
              placementId: getPlacementId(),
              adType: NativeAdType.NATIVE_BANNER_AD,
              bannerAdSize: NativeBannerAdSize.HEIGHT_100,
              width: double.infinity,
              backgroundColor: Colors.blue,
              titleColor: Colors.white,
              descriptionColor: Colors.white,
              buttonColor: Colors.deepPurple,
              buttonTitleColor: Colors.white,
              buttonBorderColor: Colors.white,
              listener: (result, value) {
                print("Native Banner Ad: $result --> $value");
                setState(() {
                  _nativeAdResult = result;
                });
              },
            ),
          ),

          Center(
            child: _getContentSection(),
          ),
        ],
      ),
    );
  }


  Widget _getContentSection() {
    switch (_nativeAdResult) {
      case NativeAdResult.ERROR:
        return RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        );
      case NativeAdResult.LOADED:
      case NativeAdResult.MEDIA_DOWNLOADED:
      case NativeAdResult.LOGGING_IMPRESSION:
        return Container();
        break;
      default:
        return Container(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Loading..',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

}