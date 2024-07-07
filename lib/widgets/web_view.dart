import 'package:flutter/material.dart';
import 'package:sadadpay_flutter/service/payment_status.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SadadWebView extends StatefulWidget {
  final String url;
  final AppBar? appBar;
  final Function onSuccess;
  final Function onFail;

  const SadadWebView(
      {required this.url,
      required this.onSuccess,
      required this.onFail,
      this.appBar,
      super.key});
  @override
  State<StatefulWidget> createState() => _SadadWebViewState();
}

class _SadadWebViewState extends State<SadadWebView> {
  var loadingPercentage = 0;
  late String _invoiceUrl;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    _invoiceUrl = widget.url;
    bool pause = false;
    bool success = false;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
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
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.endsWith(PaymentStatus.Success.name)) {
              pause = true;
              success = true;
              return NavigationDecision.navigate;
            } else if (request.url.endsWith(PaymentStatus.Failed.name)) {
              pause = true;
              return NavigationDecision.navigate;
            } else if (pause && success) {
              Future.delayed(const Duration(seconds: 15));
              widget.onSuccess();
              return NavigationDecision.prevent;
            } else if (pause && !success) {
              Future.delayed(const Duration(seconds: 15));
              widget.onFail();
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(_invoiceUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.appBar,
        body: Center(
            child: loadingPercentage == 100
                ? WebViewWidget(
                    controller: controller,
                  )
                : const CircularProgressIndicator()));
  }
}
