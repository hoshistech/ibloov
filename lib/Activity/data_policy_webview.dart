import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibloov/Activity/MyTickets.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DataPolicyWebView extends StatefulWidget {
  @override
  DataPolicyWebViewState createState() => DataPolicyWebViewState();
}

class DataPolicyWebViewState extends State<DataPolicyWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var loadingPercentage = 0;
  final urlLink = "https://www.ibloov.com/privacy-policy";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Policy'),
        backgroundColor: ColorList.colorAccent,
        iconTheme: IconThemeData(color: ColorList.colorPrimary),
        titleTextStyle: TextStyle(color: ColorList.colorPrimary, fontSize: 16),
        leading: IconButton(
          onPressed: () {
            _controller.future.then((value) async {
              if (await value.canGoBack()) {
                value.goBack();
              } else {
                Navigator.pop(context);
              }
            });
          },
          icon: Icon(Icons.arrow_back),
          color: ColorList.colorPrimary,
        ),
        actions: [
          // Container(
          //   width: 100,
          //   height: 60,
          //   margin: EdgeInsets.only(right: 20),
          //   child: Image(
          //     image: AssetImage("assets/images/logo.png"),
          //     fit: BoxFit.scaleDown,
          //     color: ColorList.colorSplashBG,
          //     colorBlendMode: BlendMode.modulate,
          //   ),
          // ),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: urlLink,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            navigationDelegate: (NavigationRequest request) {
              debugPrint('allowing navigation to $request');

              if (request.url.contains("tel:") ||
                  request.url.contains("mailto:")) {
                launch(request.url);

                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              debugPrint('fAQ Page started loading: $url');

              setState(() {
                loadingPercentage = 0;
              });
            },
            onProgress: (progress) {
              setState(() {
                loadingPercentage = progress;
              });
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');

              setState(() {
                loadingPercentage = 100;
              });
            },
            gestureNavigationEnabled: true,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
