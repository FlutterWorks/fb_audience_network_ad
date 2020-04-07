import 'package:fb_audience_network_ad/constants/fb_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fb_audience_network_ad/constants.dart';

enum NativeAdType {
  NATIVE_AD_HORIZONTAL,
  NATIVE_AD_VERTICAL,
  NATIVE_BANNER_AD,
  NATIVE_AD_TEMPLATE,
}

enum NativeAdResult {
  ERROR,
  LOADED,
  CLICKED,
  LOGGING_IMPRESSION,
  MEDIA_DOWNLOADED,
}

class NativeBannerAdSize {
  final int height;

  static const NativeBannerAdSize HEIGHT_50 = NativeBannerAdSize(height: 50);
  static const NativeBannerAdSize HEIGHT_100 = NativeBannerAdSize(height: 100);
  static const NativeBannerAdSize HEIGHT_120 = NativeBannerAdSize(height: 120);

  const NativeBannerAdSize({this.height});
}

class FacebookNativeAd extends StatefulWidget {
  final String placementId;
  final void Function(NativeAdResult, dynamic) listener;
  final NativeAdType adType;
  final NativeBannerAdSize bannerAdSize;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;
  final Color labelColor;
  final Color buttonColor;
  final Color buttonTitleColor;
  final Color buttonBorderColor;
  final bool isMediaCover;


  FacebookNativeAd({
    Key key,
    this.placementId = AD_NATIVE_PLACEMENT_ID,
    this.listener,
    @required this.adType,
    this.bannerAdSize = NativeBannerAdSize.HEIGHT_50,
    this.width = double.infinity,
    this.height = 250,
    this.backgroundColor,
    this.titleColor,
    this.descriptionColor,
    this.labelColor,
    this.buttonColor,
    this.buttonTitleColor,
    this.buttonBorderColor,
    this.isMediaCover = false,
  }) : super(key: key);

  @override
  _FacebookNativeAdState createState() => _FacebookNativeAdState();
}

class _FacebookNativeAdState extends State<FacebookNativeAd> {
  String _getChannelRegisterId() {
    String channel = NATIVE_AD_CHANNEL;
    if (defaultTargetPlatform == TargetPlatform.iOS && widget.adType == NativeAdType.NATIVE_BANNER_AD) {
      channel = NATIVE_BANNER_AD_CHANNEL;
    }
    return channel;
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        width: widget.width,
        height: (widget.adType == NativeAdType.NATIVE_BANNER_AD) ? widget.bannerAdSize.height.toDouble() : widget.height ,
        child: AndroidView(
          viewType: _getChannelRegisterId(),
          onPlatformViewCreated: _onNativeAdViewCreated,
          creationParamsCodec: StandardMessageCodec(),
          creationParams: <String, dynamic>{
            "id": widget.placementId,
            "adType": widget.adType.index,
            "banner_ad": widget.adType == NativeAdType.NATIVE_BANNER_AD ? true : false,
            "height": widget.bannerAdSize.height,
            "bg_color": widget.backgroundColor == null ? null : _getHexStringFromColor(widget.backgroundColor),
            "title_color": widget.titleColor == null ? null : _getHexStringFromColor(widget.titleColor),
            "desc_color": widget.descriptionColor == null ? null : _getHexStringFromColor(widget.descriptionColor),
            "label_color": widget.labelColor == null ? null : _getHexStringFromColor(widget.labelColor),
            "button_color": widget.buttonColor == null ? null : _getHexStringFromColor(widget.buttonColor),
            "button_title_color": widget.buttonTitleColor == null ? null : _getHexStringFromColor(widget.buttonTitleColor),
            "button_border_color": widget.buttonBorderColor == null ? null : _getHexStringFromColor(widget.buttonBorderColor),
          },
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        width: widget.width,
        height: (widget.adType == NativeAdType.NATIVE_BANNER_AD) ? widget.bannerAdSize.height.toDouble() : widget.height,
        child: UiKitView(
          viewType: _getChannelRegisterId(),
          onPlatformViewCreated: _onNativeAdViewCreated,
          creationParamsCodec: StandardMessageCodec(),
          creationParams: <String, dynamic>{
            "id": widget.placementId,
            "ad_type": widget.adType.index,
            "banner_ad": widget.adType == NativeAdType.NATIVE_BANNER_AD ? true : false,
            "height": widget.adType == NativeAdType.NATIVE_BANNER_AD ? widget.bannerAdSize.height : widget.height,
            "bg_color": widget.backgroundColor == null ? null : _getHexStringFromColor(widget.backgroundColor),
            "title_color": widget.titleColor == null ? null : _getHexStringFromColor(widget.titleColor),
            "desc_color": widget.descriptionColor == null ? null : _getHexStringFromColor(widget.descriptionColor),
            "label_color": widget.labelColor == null ? null : _getHexStringFromColor(widget.labelColor),
            "button_color": widget.buttonColor == null ? null : _getHexStringFromColor(widget.buttonColor),
            "button_title_color": widget.buttonTitleColor == null ? null : _getHexStringFromColor(widget.buttonTitleColor),
            "button_border_color": widget.buttonBorderColor == null ? null : _getHexStringFromColor(widget.buttonBorderColor),
            "is_media_cover": widget.isMediaCover,
          },
        ),
      );
    } else {
      return Container(
        width: widget.width,
        height: widget.height,
        child: Text("Banner Ads for this platform is currently not supported"),
      );
    }
  }

  String _getHexStringFromColor(Color color) => '#${color.value.toRadixString(16)}';

  void _onNativeAdViewCreated(int id) {
    final channel = MethodChannel('${_getChannelRegisterId()}_$id');
    // ignore: missing_return
    channel.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case ERROR_METHOD:
          if (widget.listener != null)
            widget.listener(NativeAdResult.ERROR, call.arguments);
          break;
        case LOADED_METHOD:
          if (widget.listener != null)
            widget.listener(NativeAdResult.LOADED, call.arguments);
          setState(() {});
          break;
        case CLICKED_METHOD:
          if (widget.listener != null)
            widget.listener(NativeAdResult.CLICKED, call.arguments);
          break;
        case LOGGING_IMPRESSION_METHOD:
          if (widget.listener != null)
            widget.listener(NativeAdResult.LOGGING_IMPRESSION, call.arguments);
          break;
        case MEDIA_DOWNLOADED_METHOD:
          if (widget.listener != null)
            widget.listener(NativeAdResult.MEDIA_DOWNLOADED, call.arguments);
          break;
      }
    });
  }
}
