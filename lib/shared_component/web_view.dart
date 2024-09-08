import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewExample extends StatelessWidget {
  final url;

  WebViewExample({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WebView Example'),
        ),
        body: InAppWebView(initialUrlRequest: URLRequest(url: WebUri(url))));
  }
}
