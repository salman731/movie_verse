
import 'dart:async';
import 'dart:ui';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewUtils
{

   HeadlessInAppWebView? headlessWebView;
   String? resultUrl;
   Completer? videoLinkCompleter;
   Map<String,String>? serverMap;

  Future loadUrlInWebView(String url,String urlExtension,String serverName,{Map<String,String>? header}) async
  {
    videoLinkCompleter = Completer();
    serverMap = Map();
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url),headers: header),
      initialSize: Size(1366,768),
      initialSettings: InAppWebViewSettings(isInspectable: false,useShouldInterceptRequest: true,useShouldOverrideUrlLoading: true,userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"),
      shouldInterceptRequest: (controller,request) async
        {
          if(request.url.rawValue.contains(urlExtension))
            {
              if(serverMap!.isEmpty)
                {
                  serverMap![serverName] = request.url.rawValue;
                  videoLinkCompleter!.complete();
                }
            }
        },

    );
    if(headlessWebView!.isRunning())
      {
        await headlessWebView!.dispose();
      }
    await headlessWebView!.run();
    await videoLinkCompleter!.future;
    return serverMap;
  }

  Future disposeWebView() async
  {
    await headlessWebView!.dispose();
  }
}