

import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_js/flutter_js.dart';

// PowVideo and StreamPlay has captcha due to it can't scrape
class VideoHostProviderUtils
{
  static Future<String?> getM3U8UrlFromFileLions(String embededUrl,String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list[3].text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      ExternalVideoPlayerLauncher.launchMxPlayer(
              m3u8Url!, MIME.applicationVndAppleMpegurl, {
            "title": title,
          });
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlFromStreamWish(String embededUrl,String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list[3].text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      ExternalVideoPlayerLauncher.launchMxPlayer(
              m3u8Url!, MIME.applicationVndAppleMpegurl, {
            "title": title,
          });
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlFromVoeSX(String embededUrl,String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script");
      String javaScriptText = list[14].text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("'hls': '","'," , javaScriptText);
      ExternalVideoPlayerLauncher.launchMxPlayer(
              m3u8Url!, MIME.applicationVndAppleMpegurl, {
            "title": title,
          });
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlFromStreamVid(String embededUrl, String title) async
  {

    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String encryptedJavascript = list[2].text;
      String decodedEval = encryptedJavascript.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{src:\"", "\",", args[1]);
        ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }
  // s-delivery33.mxcontent.net/v/2be660b15a01ae9b99978689f9c7375f.mp4?s=TlzP_V6sith8EoW5TA5MUQ&e=1711974214&_t=1711955277
  static Future<String?> getMp4UrlfromMixDrop(String embededUrl, String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script");
      String encryptedJavaScript = list[8].text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = "https:"+ LocalUtils.getStringBetweenTwoStrings("wurl=\"", "\";", args[1]);
        ExternalVideoPlayerLauncher.launchMxPlayer(
                mp4Url!, MIME.applicationVndAppleMpegurl, {
              "title": title,
            });
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlfromDropLoad(String embededUrl, String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script");
      String encryptedJavaScript = list[9].text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{file:\"", "\"}]", args[1]);
        ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlFromVidMoly(String embededUrl,String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list[8].text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      ExternalVideoPlayerLauncher.launchMxPlayer(
          m3u8Url!, MIME.applicationVndAppleMpegurl, {
        "title": title,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getMp4UrlFromStreamTape(String embededUrl,String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      String? ideooLink = document.querySelector("#ideoolink")!.text;
      List<dom.Element> list = document.querySelectorAll("script");
      String? javaScript = list[6].text;
      String? tokenString = LocalUtils.getStringBetweenTwoStrings("<script>document.getElementById('ideoolink').innerHTML =","')", javaScript);
      String? token = LocalUtils.getStringAfterStartStringToEnd("&token=", tokenString);
      String dlUrl = "https:/" + ideooLink + "&token=" + token + "&dl=1s";
      ExternalVideoPlayerLauncher.launchMxPlayer(
          dlUrl!, MIME.applicationMp4, {
        "title": title,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getMp4UrlFromVidoza(String embededUrl,String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      String? dlUrl = document.querySelector("source")!.attributes["src"];
      ExternalVideoPlayerLauncher.launchMxPlayer(
          dlUrl!, MIME.applicationMp4, {
        "title": title,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlfromVTube(String embededUrl, String title) async
  {
    try {
      String filterUrl = embededUrl.replaceAll("embed-", "");
      dom.Document document = await HtmlParsingUtils.getDomFromURL(filterUrl);
      List<dom.Element> list = document.querySelectorAll("script");
      String encryptedJavaScript = list[7].text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{file:\"", "\"}]", args[1]);
        ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getMp4UrlFromDood(String embededUrl,String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script");
      String javaScript = list[8].text;
      String baseUrl = Uri.parse(embededUrl).origin;
      String getVideoUrl = LocalUtils.getStringBetweenTwoStrings("\$.get('", "',", javaScript);
      String fullUrl = baseUrl + getVideoUrl;
      String? partialDlUrl = await HtmlParsingUtils.makeGetRequest(fullUrl,headers: {"Referer":embededUrl});
      List<String> listSplit = getVideoUrl.split("/");
      String fullDlUrl = partialDlUrl! + LocalUtils.getDoodHashValue() + "?token=${listSplit[listSplit.length - 1]}&expiry=${DateTime.now().millisecondsSinceEpoch}";
      LocalUtils.openAndPlayVideoWithMxPlayer_Android(fullDlUrl!, title, baseUrl,MIME.applicationMp4);
     /* ExternalVideoPlayerLauncher.launchMxPlayer(
          fullDlUrl!, MIME.applicationMp4, {
        "title": title,
        "headers":["referer",baseUrl]
      });*/
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlfromUpStream(String embededUrl, String title) async
  {
    try {
      dom.Document document = await HtmlParsingUtils.getDomFromURL(embededUrl);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String encryptedJavaScript = list[5].text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{file:\"", "\"}]", args[1]);
        ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getMp4UrlFromePlayVid (String embededUrl,String title) async
  {
    try {
      dom.Document iframeDocument = await HtmlParsingUtils.getDomFromURL(embededUrl);
      String? eplayMp4Url = iframeDocument.querySelector("source")!.attributes["src"];
      LocalUtils.openAndPlayVideoWithMxPlayer_Android(eplayMp4Url!, title, "https://eplayvid.net",MIME.applicationMp4);
    } catch (e) {
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

}