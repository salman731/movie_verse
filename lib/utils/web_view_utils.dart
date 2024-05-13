
import 'dart:ui';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewUtils
{

  static HeadlessInAppWebView? headlessWebView;

  static loadUrlInWebView(String url,String urlExtension,Function(String) resultUrl,{Map<String,String>? header}) async
  {
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url),headers: header),
      initialSize: Size(1366,768) ,
      initialSettings: InAppWebViewSettings(useShouldInterceptRequest: true,useShouldOverrideUrlLoading: true,userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"),
      shouldInterceptRequest: (controller,request) async
        {
          if(request.url.rawValue.contains(urlExtension))
            {
              resultUrl(request.url.rawValue);
              await headlessWebView!.dispose();
            }
        },

    );
    if(headlessWebView!.isRunning())
      {
        await headlessWebView!.dispose();
      }
    await headlessWebView!.run();
  }
}