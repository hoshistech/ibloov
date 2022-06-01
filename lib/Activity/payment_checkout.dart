import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibloov/Activity/MyTickets.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentCheckout extends StatefulWidget {
  final String paymentLink;

  PaymentCheckout(this.paymentLink);

  @override
  PaymentCheckoutState createState() => PaymentCheckoutState();
}

class PaymentCheckoutState extends State<PaymentCheckout> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _paymentWasSuccessful = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: ColorList.colorAccent,
        iconTheme: IconThemeData(color: ColorList.colorPrimary),
        titleTextStyle: TextStyle(color: ColorList.colorPrimary, fontSize: 16),
        leading: IconButton(
          onPressed: () {
            if (_paymentWasSuccessful) {
              Future.delayed(Duration(seconds: 4), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyTickets(fromPaystackCheckout: true)),
                );
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back),
          color: ColorList.colorPrimary,
        ),
        actions: [
          Container(
            width: 100,
            height: 60,
            margin: EdgeInsets.only(right: 20),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              fit: BoxFit.scaleDown,
              color: ColorList.colorSplashBG,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: widget.paymentLink,
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
          debugPrint('Page started loading: $url');
        },
        onPageFinished: (String url) {
          //https://my-app-gm6tf.ondigitalocean.app/payment-successful?trxref=PYSTK_20220526_03443320&reference=PYSTK_20220526_03443320
          debugPrint('Page finished loading: $url');

          if (url.contains("payment-successful")) {
            if (!_paymentWasSuccessful) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyTickets(fromPaystackCheckout: true)),
                );
              });
            }

            _paymentWasSuccessful = true;
          }
        },
        gestureNavigationEnabled: true,
        // backgroundColor: const Color(0x00000000),
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
