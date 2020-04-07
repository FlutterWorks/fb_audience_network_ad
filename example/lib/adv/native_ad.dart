import 'package:fb_audience_network_ad/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../common/fb_constants.dart';

class NativeAdWidget extends StatefulWidget {
  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {

  NativeAdResult _nativeAdResult;

  String getPlacementId() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return ANDROID_AD_NATIVE_PLACEMENT_ID;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return IOS_AD_NATIVE_PLACEMENT_ID;
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
              adType: NativeAdType.NATIVE_AD_HORIZONTAL,
              width: double.infinity,
              height: 300,
              backgroundColor: Colors.white,
              titleColor: Color.fromARGB(0xff, 0x00, 0x1E, 0x31),
              descriptionColor: Color.fromARGB(0xff, 0x00, 0x1E, 0x31),
              buttonColor: Color.fromARGB(0xff, 0xf8, 0xd0, 0x00),
              buttonTitleColor: Color.fromARGB(0xff, 0x00, 0x1E, 0x31),
              buttonBorderColor: Colors.white,
              listener: (result, value) {
                setState(() {
                  _nativeAdResult = result;
                  print("NativeAdWidget Ad : $result -->  $value");
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