# flutter_plugin_audience_network_ad

Plugin to integrate Facebook Native Ad to Flutter application


```dart
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
```

```dart
void _loadInterstitialAd() {
  FacebookInterstitialAd.loadInterstitialAd(
    placementId: getPlacementId(),
    listener: (result, value) {
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
```

```dart
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
```

- `placementID`: required placement ID from Facebook. If you want to run test ads, please use `"YOUR_PLACEMENT_ID"`

## Features Request
just facebook audience ad network support Android and iOS.