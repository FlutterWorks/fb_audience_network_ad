import 'package:fb_audience_network_ad/ad/ad_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/fb_constants.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {

  BannerAdResult _bannerAdResult;

  String getPlacementId() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return ANDROID_AD_BANNER_PLACEMENT_ID;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return IOS_AD_BANNER_PLACEMENT_ID;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: FacebookBannerAd(
              placementId: getPlacementId(),
              bannerSize: BannerSize.STANDARD,
              listener: (result, value) {
                setState(() {
                  _bannerAdResult = result;
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
    switch (_bannerAdResult) {
      case BannerAdResult.ERROR:
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
      case BannerAdResult.LOADED:
      case BannerAdResult.CLICKED:
      case BannerAdResult.LOGGING_IMPRESSION:
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

