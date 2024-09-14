import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'default_text.dart';

class ShowWebView extends StatefulWidget {
  final String url;
  final int lectureNumber;

  const ShowWebView(
      {super.key, required this.url, required this.lectureNumber});

  @override
  State<ShowWebView> createState() => _ShowWebViewState();
}

class _ShowWebViewState extends State<ShowWebView> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: textInApp(text: "Lecture ${widget.lectureNumber}"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                color: Colors.amber,
                value: loadingPercentage / 100.0,
              ),
          ],
        ));
  }
}
