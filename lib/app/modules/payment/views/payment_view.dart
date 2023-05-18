import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key, this.paymentUrl});
  final String? paymentUrl;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late WebViewController _controller;
  String response = "";
  bool success = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: "${widget.paymentUrl}",
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          navigationDelegate: (request) async {
            // log(request.url.toString());
            if (request.url.contains('Return')) {
              ///await Future.delayed(const Duration(seconds: 4));
              // Close current window
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.navigate; // Default decision
            }
          },
          javascriptChannels: {
            JavascriptChannel(
                name: 'Print',
                onMessageReceived: (JavascriptMessage message) {
                  var jsonData = jsonDecode(message.message);
                })
          },
          onPageFinished: (_) {
            if (Platform.isAndroid) {
              _controller
                  .runJavascriptReturningResult(
                      "document.documentElement.innerHTML")
                  .then((value) async {
                var jsonData = jsonDecode(value);
                log(jsonData);
                if (jsonData.contains(
                    '<input name="auth_code" type="hidden" value="00">')) {
                  success = true;
                  log("----------------------------------------------------------------");
                  log('success');
                  log("----------------------------------------------------------------");
                  await Future.delayed(const Duration(milliseconds: 260));
                  Get.back(result: success);
                } else if (jsonData.contains(
                    '<input name="auth_code" type="hidden" value="01">')) {
                  success = false;
                  log("----------------------------------------------------------------");
                  log('Failed');
                  log("----------------------------------------------------------------");
                  await Future.delayed(const Duration(milliseconds: 260));
                  Get.back(result: success);
                } else {
                  log(jsonData);
                }
              });
            } else {
              _controller
                  .runJavascriptReturningResult(
                      "document.documentElement.innerHTML")
                  .then((value) async {
                if (value.contains(
                        '<input name="response" type="hidden" value="Approved">') &&
                    value.contains(
                        '<input name="auth_code" type="hidden" value="00">')) {
                  success = true;
                  log("----------------------------------------------------------------");
                  log('success');
                  log("----------------------------------------------------------------");
                  await Future.delayed(const Duration(milliseconds: 260));
                  Get.back(result: success);
                } else if (value.contains(
                        '<input name="response" type="hidden" value="Failed">') &&
                    value.contains(
                        '<input name="auth_code" type="hidden" value="01">')) {
                  success = false;
                  log("----------------------------------------------------------------");
                  log('Failed');
                  log("----------------------------------------------------------------");
                  await Future.delayed(const Duration(milliseconds: 260));
                  Get.back(result: success);
                } else {
                  // log(value.toString());
                }
              });
            }
          },
        ));
  }
}
