import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewWidget extends StatefulWidget {
   InAppWebViewWidget({super.key});

  @override
  State<InAppWebViewWidget> createState() => _InAppWebViewWidgetState();
}

class _InAppWebViewWidgetState extends State<InAppWebViewWidget> {

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
      isInspectable: kDebugMode);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest:
      URLRequest(url: WebUri("https://primewire.tf/")),
      initialSettings: settings,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStart: (controller, url) {

      },
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT);
      },
      onLoadStop: (controller, url) async {

      },
      onReceivedError: (controller, request, error) {

      },
      onProgressChanged: (controller, progress) {

      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {

      },
      onConsoleMessage: (controller, consoleMessage) {
        if (kDebugMode) {
          print(consoleMessage);
        }
      },
    );
  }
}
