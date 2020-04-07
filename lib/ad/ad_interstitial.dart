import 'package:fb_audience_network_ad/constants/fb_constants.dart';
import 'package:flutter/services.dart';

import 'package:fb_audience_network_ad/constants.dart';

enum InterstitialAdResult {
  DISPLAYED,
  DISMISSED,
  ERROR,
  LOADED,
  CLICKED,
  LOGGING_IMPRESSION,
}

class FacebookInterstitialAd {
  static void Function(InterstitialAdResult, dynamic) _listener;

  static const _channel = const MethodChannel(INTERSTITIAL_AD_CHANNEL);

  static Future<bool> loadInterstitialAd({
    String placementId = AD_INTERSTITIAL_PLACEMENT_ID,
    Function(InterstitialAdResult, dynamic) listener,
  }) async {
    try {
      final args = <String, dynamic>{
        "id": placementId,
      };

      final result = await _channel.invokeMethod(
        LOAD_INTERSTITIAL_METHOD,
        args,
      );
      _channel.setMethodCallHandler(_interstitialMethodCall);
      _listener = listener;

      return result;
    } on PlatformException {
      return false;
    }
  }


  static Future<bool> showInterstitialAd({int delay = 0}) async {
    try {
      final args = <String, dynamic>{
        "delay": delay,
      };

      final result = await _channel.invokeMethod(
        SHOW_INTERSTITIAL_METHOD,
        args,
      );

      return result;
    } on PlatformException {
      return false;
    }
  }


  static Future<bool> destroyInterstitialAd() async {
    try {
      final result = await _channel.invokeMethod(DESTROY_INTERSTITIAL_METHOD);
      return result;
    } on PlatformException {
      return false;
    }
  }


  static Future<dynamic> _interstitialMethodCall(MethodCall call) {
    switch (call.method) {
      case DISPLAYED_METHOD:
        if (_listener != null)
          _listener(InterstitialAdResult.DISPLAYED, call.arguments);
        break;
      case DISMISSED_METHOD:
        if (_listener != null)
          _listener(InterstitialAdResult.DISMISSED, call.arguments);
        break;
      case ERROR_METHOD:
        if (_listener != null)
          _listener(InterstitialAdResult.ERROR, call.arguments);
        break;
      case LOADED_METHOD:
        if (_listener != null)
          _listener(InterstitialAdResult.LOADED, call.arguments);
        break;
      case CLICKED_METHOD:
        if (_listener != null)
          _listener(InterstitialAdResult.CLICKED, call.arguments);
        break;
      case LOGGING_IMPRESSION_METHOD:
        if (_listener != null)
          _listener(InterstitialAdResult.LOGGING_IMPRESSION, call.arguments);
        break;
    }
    return Future.value(true);
  }
}