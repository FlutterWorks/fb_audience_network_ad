import 'package:fb_audience_network_ad/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../common/fb_constants.dart';

class InterstitialAdWidget extends StatefulWidget {
  @override
  _InterstitialAdWidgetState createState() => _InterstitialAdWidgetState();
}

class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {

  InterstitialAdResult _interstitialAdResult;

  String getPlacementId() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return ANDROID_AD_INTERSTITIAL_PLACEMENT_ID;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return IOS_AD_INTERSTITIAL_PLACEMENT_ID;
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: getPlacementId(),
      listener: (result, value) {
        print("Interstitial Ad: $result --> $value");
        setState(() {
          _interstitialAdResult = result;
        });
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd();
        }
        if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
          _loadInterstitialAd();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getContentSection(),
      ),
    );
  }


  // ignore: missing_return
  Widget _getContentSection() {
    switch (_interstitialAdResult) {
      case InterstitialAdResult.ERROR:
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
      case InterstitialAdResult.DISPLAYED:
        return Container();
        break;
      case InterstitialAdResult.DISMISSED:
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