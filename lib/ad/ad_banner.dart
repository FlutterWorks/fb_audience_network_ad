import 'package:fb_audience_network_ad/constants/fb_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fb_audience_network_ad/constants.dart';

class BannerSize {
  final int width;
  final int height;

  static const BannerSize STANDARD = BannerSize(width: 320, height: 50);
  static const BannerSize LARGE = BannerSize(width: 320, height: 90);
  static const BannerSize MEDIUM_RECTANGLE = BannerSize(width: 320, height: 250);

  const BannerSize({this.width = 320, this.height = 50});
}

enum BannerAdResult {
  ERROR,
  LOADED,
  CLICKED,
  LOGGING_IMPRESSION,
}

class FacebookBannerAd extends StatefulWidget {
  final Key key;
  final String placementId;
  final BannerSize bannerSize;

  final void Function(BannerAdResult, dynamic) listener;

  FacebookBannerAd({
    this.key,
    this.placementId = AD_BANNER_PLACEMENT_ID,
    this.bannerSize = BannerSize.STANDARD,
    this.listener,
  }) : super(key: key);

  @override
  _FacebookBannerAdState createState() => _FacebookBannerAdState();
}

class _FacebookBannerAdState extends State<FacebookBannerAd> {
  double containerHeight = 0.5;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        height: containerHeight,
        color: Colors.transparent,
        child: AndroidView(
          viewType: BANNER_AD_CHANNEL,
          onPlatformViewCreated: _onBannerAdViewCreated,
          creationParams: <String, dynamic>{
            "id": widget.placementId,
            "width": widget.bannerSize.width,
            "height": widget.bannerSize.height,
          },
          creationParamsCodec: StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        height: containerHeight,
        color: Colors.transparent,
        child: Container(
          width: widget.bannerSize.width.toDouble(),
          child: Center(
            child: UiKitView(
              viewType: BANNER_AD_CHANNEL,
              onPlatformViewCreated: _onBannerAdViewCreated,
              creationParams: <String, dynamic>{
                "id": widget.placementId,
                "width": widget.bannerSize.width,
                "height": widget.bannerSize.height,
              },
              creationParamsCodec: StandardMessageCodec(),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: widget.bannerSize.height <= -1
            ? double.infinity
            : widget.bannerSize.height.toDouble(),
        child: Center(
          child: Text("Banner Ads for this platform is currently not supported"),
        ),
      );
    }
  }

  void _onBannerAdViewCreated(int id) async {
    final channel = MethodChannel('${BANNER_AD_CHANNEL}_$id');

    // ignore: missing_return
    channel.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case ERROR_METHOD:
          if (widget.listener != null)
            widget.listener(BannerAdResult.ERROR, call.arguments);
          break;
        case LOADED_METHOD:
          setState(() {
            containerHeight = widget.bannerSize.height <= -1
                ? double.infinity
                : widget.bannerSize.height.toDouble();
          });
          if (widget.listener != null)
            widget.listener(BannerAdResult.LOADED, call.arguments);
          break;
        case CLICKED_METHOD:
          if (widget.listener != null)
            widget.listener(BannerAdResult.CLICKED, call.arguments);
          break;
        case LOGGING_IMPRESSION_METHOD:
          if (widget.listener != null)
            widget.listener(BannerAdResult.LOGGING_IMPRESSION, call.arguments);
          break;
      }
    });
  }

}