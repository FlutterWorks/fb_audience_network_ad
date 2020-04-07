import 'package:flutter/material.dart';

import 'adv/banner_ad.dart';
import 'adv/interstitial_ad.dart';
import 'adv/native_ad.dart';
import 'adv/native_banner_ad.dart';

/*
 */
class FacebookAdPage extends StatefulWidget {
  @override
  State createState() {
    return _FacebookAdPageState();
  }
}

class _FacebookAdPageState extends State<FacebookAdPage> with WidgetsBindingObserver{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FacebookAdPage',
      theme: ThemeData(
        primaryColor: const Color(0xFFF2BF3F),
        primaryColorLight: const Color(0xFFF7E0AA),
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder> {
        '/BannerAdWidget': (BuildContext context) => BannerAdWidget(),
        '/InterstitialAdWidget': (BuildContext context) => InterstitialAdWidget(),
        '/NativeAdWidget': (BuildContext context) => NativeAdWidget(),
        '/NativeAdBannerWidget': (BuildContext context) => NativeAdBannerWidget(),
      },
    );
  }
}


class HomePage extends StatefulWidget {
  final String title = 'Flutter Widget';
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  static const List<String> _products = const [
    '/BannerAdWidget',
    '/InterstitialAdWidget',
    '/NativeAdWidget',
    '/NativeAdBannerWidget',
  ];

  Widget _buildProductItem(BuildContext context, int index) {
    return Container(
      child: FlatButton(
        onPressed: () {
          print("_buildProductItem >> _products > index.toString() :: " + index.toString() + " , _products[index] : " + _products[index]);
          Navigator.of(context).pushNamed(_products[index]);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
            child: Row(children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: _products[index],
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "FacebookAdPage",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: ListView.builder(
            itemBuilder: _buildProductItem,
            itemCount: _products.length,
          ),
        ),
      ),
    );
  }
}