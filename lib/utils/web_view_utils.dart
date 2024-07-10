
import 'dart:async';
import 'dart:ui';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as dom;


class WebViewUtils
{

   HeadlessInAppWebView? headlessWebView;
   HeadlessInAppWebView? netuHeadlessWebView;
   String? resultUrl;
   Completer? videoLinkCompleter;
   InAppWebViewController? inAppWebViewController;
   String? finalUrl;

  Future<String> loadUrlInWebView(String url,String urlExtension,{Map<String,String>? header}) async
  {
    videoLinkCompleter = Completer();
    finalUrl = "";
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url),headers: header),
      initialSize: Size(1366,768),
      initialSettings: InAppWebViewSettings(isInspectable: false,useShouldInterceptRequest: true,useShouldOverrideUrlLoading: true,userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36", ),
      shouldInterceptRequest: (controller,request) async
        {
          if(request.url.rawValue.contains(urlExtension))
            {
              if(finalUrl!.isEmpty)
                {
                  finalUrl = request.url.rawValue;
                  videoLinkCompleter!.complete();
                }
            }
        },
        onWebViewCreated: (controller)
        {
          inAppWebViewController = controller;
        },

      onLoadStop: (controller,url) async {

        /*String? html = await inAppWebViewController!.getHtml();
        dom.Document pageDocument;
        pageDocument = WebUtils.getDomfromHtml(html!);
        print(pageDocument.querySelectorAll("iframe"));
        String finalUrl = url!.origin + LocalUtils.getStringBetweenTwoStrings("self.location.replace('", "');", html!);
        if (url.rawValue.contains("/f/")) {
          await inAppWebViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(finalUrl),));
        }
        if(url!.path.contains("watch_video.php"))
          {
            var result = await inAppWebViewController!.evaluateJavascript(source: "document.querySelector(\"iframe\").contentWindow.document.body.innerHTML;");
            print(result);
            await inAppWebViewController!.evaluateJavascript(source: ""
              "var clickEvent = new MouseEvent(\"click\", {\"view\": window,\"bubbles\": true,\"cancelable\": false});"
              "var element = document.querySelector(\"iframe\").contentWindow.document.getElementById(\"bot_click\");"
              "element.dispatchEvent(clickEvent);");

              return;
          }*/
      }

    );
    if(headlessWebView!.isRunning())
      {
        await headlessWebView!.dispose();
      }
    await headlessWebView!.run();
    await videoLinkCompleter!.future;
    return finalUrl!;
  }

   /*Future<String> loadNetuInWebView(String url,{Map<String,String>? header}) async
   {
     videoLinkCompleter = Completer();
     finalUrl = "";
     netuHeadlessWebView = HeadlessInAppWebView(
       initialUrlRequest: URLRequest(url: WebUri(url),headers: header),
       initialSize: Size(1366,768),
       initialSettings: InAppWebViewSettings(isInspectable: false,useShouldInterceptRequest: true,useShouldOverrideUrlLoading: true,userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"),
       shouldInterceptRequest: (controller,request) async
       {
         if(request.url.rawValue.contains(urlExtension))
         {
           if(finalUrl!.isEmpty)
           {
             finalUrl = request.url.rawValue;
             videoLinkCompleter!.complete();
           }
         }
       },

     );
     if(headlessWebView!.isRunning())
     {
       await headlessWebView!.dispose();
     }
     return finalUrl!;
   }*/

  Future disposeWebView() async
  {
    await headlessWebView!.dispose();
  }

 /* Future disposeNetuWebView() async
   {
     await netuHeadlessWebView!.dispose();
  }*/
}