import 'package:fb_audience_network_ad_example/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    await tester.pumpWidget(FacebookAdPage());
    expect(
      find.byWidgetPredicate(
            (Widget widget) =>
        widget is Text && widget.data.startsWith('Running on:'),
      ),
      findsOneWidget,
    );
  });
}
