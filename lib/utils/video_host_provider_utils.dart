
import 'dart:convert';

import 'package:Movieverse/controllers/video_player_screen_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/enums/video_quality_enum.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_video_detail.dart';
import 'package:Movieverse/models/pr_movies/vid_src_to_source.dart';
import 'package:Movieverse/models/pr_movies/vid_src_to_source_response.dart';
import 'package:Movieverse/models/pr_movies/vid_src_to_url_response.dart';
import 'package:Movieverse/screens/video_player/video_player_screen.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_view_utils.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:http/http.dart';
import 'package:string_validator/string_validator.dart';

// PowVideo and StreamPlay has captcha due to it can't scrape
class VideoHostProviderUtils
{
  VideoPlayerScreenController videoPlayerScreenController = Get.put(VideoPlayerScreenController());
  static MethodChannel kotlinMethodChannel = MethodChannel("KOTLIN_CHANNEL");
  static Future<String?> getM3U8UrlFromFileLions(String embededUrl,String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("/f/", "/v/");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list.where((element) => element.text.contains("sources: [{file:\"")).first.text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      //Get.to(VideoPlayerScreen(m3u8Url,title!,));
      LocalUtils.startVideoPlayer(m3u8Url, title);
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
              m3u8Url!, MIME.applicationVndAppleMpegurl, {
            "title": title,
          });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlFromStreamWish(String embededUrl,String title,{bool isVideotoEmbededAllowed = false,Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://streamwish.to/", "https://streamwish.to/e/");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list.where((element) => element.text.contains("sources: [{file:\"")).first.text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      //Get.to(VideoPlayerScreen(m3u8Url,title!,));
      LocalUtils.startVideoPlayer(m3u8Url, title);
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
              m3u8Url!, MIME.applicationVndAppleMpegurl, {
            "title": title,
          });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlFromVoeSX(String embededUrl,String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://voe.sx/", "https://voe.sx/e/");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script");
      String javaScriptText = list.where((element) => element.text.contains("'hls': '")).first.text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("'hls': '","'," , javaScriptText);
      //Get.to(VideoPlayerScreen(m3u8Url,title!,));
      if(isBase64(m3u8Url))
        {
          m3u8Url = String.fromCharCodes(base64Decode(m3u8Url));
        }
      LocalUtils.startVideoPlayer(m3u8Url, title);
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
              m3u8Url!, MIME.applicationVndAppleMpegurl, {
            "title": title,
          });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlFromStreamVid(String embededUrl, String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {

    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://streamvid.net/", "https://streamvid.net/embed-");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String encryptedJavascript = list.where((element) => element.text.contains("eval")).first.text;
      String decodedEval = encryptedJavascript.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{src:\"", "\",", args[1]);
        LocalUtils.startVideoPlayer(mp4Url, title);
        //Get.to(VideoPlayerScreen(mp4Url,title!,));
        /*ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });*/
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }
  // s-delivery33.mxcontent.net/v/2be660b15a01ae9b99978689f9c7375f.mp4?s=TlzP_V6sith8EoW5TA5MUQ&e=1711974214&_t=1711955277
  static Future<String?> getMp4UrlfromMixDrop(String embededUrl, String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("/f/", "/e/");
    }
    if(!embededUrl.contains("https://") && !embededUrl.contains("http://"))
      {
        if(embededUrl.contains("//"))
          {
            embededUrl=  embededUrl.replaceAll("//", "https://");
          }
      }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script");
      String encryptedJavaScript = list.where((element) => element.text.contains("eval")).first.text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = "https:"+ LocalUtils.getStringBetweenTwoStrings("wurl=\"", "\";", args[1]);
        //Get.to(VideoPlayerScreen(mp4Url,title!,));
        LocalUtils.startVideoPlayer(mp4Url, title);
        /*ExternalVideoPlayerLauncher.launchMxPlayer(
                mp4Url!, MIME.applicationVndAppleMpegurl, {
              "title": title,
            });*/
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlfromDropLoad(String embededUrl, String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://dropload.io/", "https://dropload.io/e");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script");
      String encryptedJavaScript = list.where((element) => element.text.contains("eval")).first.text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{file:\"", "\"}]", args[1]);
        //Get.to(VideoPlayerScreen(mp4Url,title!,));
        LocalUtils.startVideoPlayer(mp4Url, title);
        /*ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });*/
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlFromVidMoly(String embededUrl,String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      if(!embededUrl.contains("/w/"))
      {
      embededUrl = embededUrl.replaceAll("https://vidmoly.to/", "https://vidmoly.to/embed-");

      }
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script");
      String javaScriptText = list.where((element) => element.text.contains("sources: [{file:\"")).first.text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      //Get.to(VideoPlayerScreen(m3u8Url,title!,));
      LocalUtils.startVideoPlayer(m3u8Url, title);
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
          m3u8Url!, MIME.applicationVndAppleMpegurl, {
        "title": title,
      });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getMp4UrlFromStreamTape(String embededUrl,String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("/v/", "/e/");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      String? ideooLink = document.querySelector("#ideoolink")!.text;
      List<dom.Element> list = document.querySelectorAll("script");
      String? javaScript = list[6].text;
      String? tokenString = LocalUtils.getStringBetweenTwoStrings("<script>document.getElementById('ideoolink').innerHTML =","')", javaScript);
      String? token = LocalUtils.getStringAfterStartStringToEnd("&token=", tokenString);
      String dlUrl = "https:/" + ideooLink + "&token=" + token + "&dl=1s";
      //Get.to(VideoPlayerScreen(dlUrl,title!));
      LocalUtils.startVideoPlayer(dlUrl, title);
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
          dlUrl!, MIME.applicationMp4, {
        "title": title,
      });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getMp4UrlFromVidoza(String embededUrl,String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://vidoza.net/", "https://vidoza.net/embed-");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      String? dlUrl = document.querySelector("source")!.attributes["src"];
      LocalUtils.startVideoPlayer(dlUrl!, title);
      //Get.to(VideoPlayerScreen(dlUrl!,title!,));
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
          dlUrl!, MIME.applicationMp4, {
        "title": title,
      });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlfromVTube(String embededUrl, String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    try {
      String filterUrl = embededUrl.replaceAll("embed-", "");
      dom.Document document = await WebUtils.getDomFromURL_Get(filterUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script");
      String encryptedJavaScript = list[7].text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{file:\"", "\"}]", args[1]);
        //Get.to(VideoPlayerScreen(mp4Url,title!,));
        LocalUtils.startVideoPlayer(mp4Url, title);
        /*ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });*/
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getMp4UrlFromDood(String embededUrl,String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {

    if (isVideotoEmbededAllowed) {
      embededUrl = (await WebUtils.getOriginalUrl(embededUrl))!;
      embededUrl = embededUrl.replaceAll("/d/", "/e/");
    }
    try {
      String? orginalUrl = await WebUtils.getOriginalUrl(embededUrl);
      dom.Document document = await WebUtils.getDomFromURL_Get(orginalUrl!,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script");
      String javaScript = list.where((element) => element.text.contains("pass_md5")).first.text;
      String baseUrl = Uri.parse(orginalUrl).origin;
      String getVideoUrl = LocalUtils.getStringBetweenTwoStrings("\$.get('", "',", javaScript);
      String fullUrl = baseUrl + getVideoUrl;
      String? partialDlUrl = await WebUtils.makeGetRequest(fullUrl,headers: {"Referer":orginalUrl});
      List<String> listSplit = getVideoUrl.split("/");
      String fullDlUrl = partialDlUrl! + LocalUtils.getDoodHashValue() + "?token=${listSplit[listSplit.length - 1]}&expiry=${DateTime.now().millisecondsSinceEpoch}";
      LocalUtils.startVideoPlayer(fullDlUrl, title,headers:{"Referer":baseUrl} );
      //Get.to(VideoPlayerScreen(fullDlUrl,title!,headers: {"Referer":baseUrl},));
      //LocalUtils.openAndPlayVideoWithMxPlayer_Android(fullDlUrl!, title, baseUrl,MIME.applicationMp4);

    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlfromUpStream(String embededUrl, String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl =  embededUrl.replaceAll("https://upstream.to/", "https://upstream.to/embed-") + ".html";
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String encryptedJavaScript = list.where((element) => element.text.contains("eval")).first.text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{file:\"", "\"}]", args[1]);
        LocalUtils.startVideoPlayer(mp4Url, title);
       // Get.to(VideoPlayerScreen(mp4Url,title!,));
        /*ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });*/
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlfromFileMoon(String embededUrl, String title,{bool isVideotoEmbededAllowed = false,Map<String,String>? headers,Function(String)? canReturn}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl =  embededUrl.replaceAll("https://upstream.to/", "https://upstream.to/embed-") + ".html";
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String encryptedJavaScript = list.where((element) => element.text.contains("eval")).first.text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        mp4Url = LocalUtils.getStringBetweenTwoStrings("sources:[{file:\"", "\"}]", args[1]);
        if(canReturn != null)
          {
            return canReturn(mp4Url);
          }
        else
          {
            LocalUtils.startVideoPlayer(mp4Url, title);
          }

        //Get.to(VideoPlayerScreen(mp4Url,title!,));
        /*ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });*/
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<String?> getM3U8UrlFromVidHideVip(String embededUrl,String title,{bool isVideotoEmbededAllowed = false,Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://vidhidevip.com/", "https://vidhidevip.com/");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list[3].text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      LocalUtils.startVideoPlayer(m3u8Url, title);
      //Get.to(VideoPlayerScreen(m3u8Url,title!,));
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
          m3u8Url!, MIME.applicationVndAppleMpegurl, {
        "title": title,
      });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlFromMinoplres(String embededUrl,String title,{bool isVideotoEmbededAllowed = false,Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://minoplres.xyz/", "https://minoplres.xyz/embed-");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list.where((element) => element.text.contains("sources: [{file:\"")).first.text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]" , javaScriptText);
      LocalUtils.startVideoPlayer(m3u8Url, title,headers: {"Referer":"https://minoplres.xyz"});
      //Get.to(VideoPlayerScreen(m3u8Url,title!,headers: {"Referer":"https://minoplres.xyz"},));
     // LocalUtils.openAndPlayVideoWithMxPlayer_Android(m3u8Url!, title, "https://minoplres.xyz",MIME.applicationVndAppleMpegurl);
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
          m3u8Url!, MIME.applicationVndAppleMpegurl, {
        "title": title,
      });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getM3U8UrlFromEmbedPK(String embededUrl,String title,{bool isVideotoEmbededAllowed = false,Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("https://embedpk.net/", "https://embedpk.net/embed-");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String encryptedJavaScript = list.where((element) => element.text.contains("eval(function")).first.text;
      String evalStr = LocalUtils.getStringfromStartToEnd("eval", encryptedJavaScript);
      String decodedEval = evalStr.replaceAll("eval", "console.log");
      JavascriptRuntime flutterJs = getJavascriptRuntime();
      late String mp4Url;
      dynamic logFn(dynamic args) {
        if(args[1].contains("{src:\""))
          {
            mp4Url = LocalUtils.getStringBetweenTwoStrings("{src:\"", "\",", args[1]);
          }
        else
          {
            mp4Url = LocalUtils.getStringBetweenTwoStrings("{sources:[{file:\"", "\",", args[1]);
          }
        LocalUtils.startVideoPlayer(mp4Url, title);
        //Get.to(VideoPlayerScreen(mp4Url,title!,));
       /* ExternalVideoPlayerLauncher.launchMxPlayer(
            mp4Url!, MIME.applicationMp4, {
          "title": title,
        });*/
      }
      final channelCallbacks = JavascriptRuntime.channelFunctionsRegistered[flutterJs.getEngineInstanceId()];
      channelCallbacks!["ConsoleLog"] = logFn;
      JsEvalResult jsResult = flutterJs.evaluate(decodedEval);

    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }

  static Future<String?> getMp4UrlFromePlayVid (String embededUrl,String title) async
  {
    try {
      dom.Document iframeDocument = await WebUtils.getDomFromURL_Get(embededUrl);
      String? eplayMp4Url = iframeDocument.querySelector("source")!.attributes["src"];
      LocalUtils.startVideoPlayer(eplayMp4Url!, title,headers: {"Referer":"https://eplayvid.net"});
      //Get.to(VideoPlayerScreen(eplayMp4Url!,title!,headers: {"Referer":"https://eplayvid.net"},));
      //LocalUtils.openAndPlayVideoWithMxPlayer_Android(eplayMp4Url!, title, "https://eplayvid.net",MIME.applicationMp4);
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Future<Map<String,String>> getVidPlayMyCloudM3U8Links(String embedUrl,VideoHosterEnum videoHosterEnum,{bool isWithServerName = false}) async
  {
    String currentVidPlayServer = LocalUtils.getStringBeforString("/e/", embedUrl);
    Map<String,String> map = Map();
    const String VIDPLAY_KEY_URL = "https://raw.githubusercontent.com/KillerDogeEmpire/vidplay-keys/keys/keys.json";
    String? keysResponse = await WebUtils.makeGetRequest(VIDPLAY_KEY_URL);
    List<String> keys = (jsonDecode(keysResponse!) as List<dynamic>).map((e) => e.toString()).toList();
    String id = LocalUtils.getStringBetweenTwoStrings("/e/", "?", embedUrl);
    String encodedId = await kotlinMethodChannel.invokeMethod("getEncodeId",{"id":id,"keys": keys,});
    String futokenUrl = currentVidPlayServer + "/futoken";
    String? scriptResponse = await WebUtils.makeGetRequest(futokenUrl,headers: {"Referer":embedUrl});
    String decodedUrl = await kotlinMethodChannel.invokeMethod("getMediaUrl",{"script":scriptResponse,"mainUrl":currentVidPlayServer,"embededUrl":embedUrl,"id":encodedId});
    String? sourceResponse = await WebUtils.makeGetRequest(decodedUrl);
    String finalM3u8Link = jsonDecode(sourceResponse!)["result"]["sources"][0]["file"];
    String? m3u8Links = await WebUtils.makeGetRequest(finalM3u8Link);
    List<String> rawLinks = m3u8Links!.split("\n");

    for(int i = 0; i< rawLinks.length;i++)
    {
      if(rawLinks[i].contains("x1080"))
      {
        if(videoHosterEnum == VideoHosterEnum.VidPlay)
        {
          String title = "";
          if(isWithServerName)
            {
              title = VideoHosterEnum.VidPlay.name+"(1080)";
            }
          else
            {
              title = "1080";
            }
          map[title] = LocalUtils.getStringBeforString("list", finalM3u8Link) + rawLinks[i+1];
        }
        else if(videoHosterEnum == VideoHosterEnum.MyCloud)
        {
          map["1080"] = finalM3u8Link.replaceAll("list.m3u8",rawLinks[i+1]);
        }
      }
      if(rawLinks[i].contains("x720"))
      {
        if(videoHosterEnum == VideoHosterEnum.VidPlay)
        {
          String title = "";
          if(isWithServerName)
          {
            title = VideoHosterEnum.VidPlay.name+"(720)";
          }
          else
          {
            title = "720";
          }
          map[title] = LocalUtils.getStringBeforString("list", finalM3u8Link) + rawLinks[i+1];
        }
        else if(videoHosterEnum == VideoHosterEnum.MyCloud)
        {
          map["720"] = finalM3u8Link.replaceAll("list.m3u8",rawLinks[i+1]);
        }
      }

      if(rawLinks[i].contains("x480"))
      {
        if(videoHosterEnum == VideoHosterEnum.VidPlay)
        {
          String title = "";
          if(isWithServerName)
          {
            title = VideoHosterEnum.VidPlay.name+"(480)";
          }
          else
          {
            title = "480";
          }
          map[title] = LocalUtils.getStringBeforString("list", finalM3u8Link) + rawLinks[i+1];
        }
        else if(videoHosterEnum == VideoHosterEnum.MyCloud)
        {
          map["480"] = finalM3u8Link.replaceAll("list.m3u8",rawLinks[i+1]);
        }
      }

      if(rawLinks[i].contains("x360"))
      {
        if(videoHosterEnum == VideoHosterEnum.VidPlay)
        {
          String title = "";
          if(isWithServerName)
          {
            title = VideoHosterEnum.VidPlay.name+"(360)";
          }
          else
          {
            title = "360";
          }
          map[title] = LocalUtils.getStringBeforString("list", finalM3u8Link) + rawLinks[i+1];
        }
        else if(videoHosterEnum == VideoHosterEnum.MyCloud)
        {
          map["360"] = finalM3u8Link.replaceAll("list.m3u8",rawLinks[i+1]);
        }
      }
    }
    return map;
  }

  // For rabbit stream
  static Future<Map<String,String>> getVidCloudAndUpCloudM3U8Links (String embedUrl, String extension,String serverName,{Map<String,String>? header}) async
  {
    Map<String,String> linksMap = Map();
    WebViewUtils webViewUtils = WebViewUtils();
    String finalUrl = await webViewUtils.loadUrlInWebView(embedUrl,extension,header: header);
    webViewUtils.disposeWebView();
    String? qualityLinks;
    qualityLinks =  await WebUtils.makeGetRequest(finalUrl!);
    List<String> qualityList = qualityLinks!.split("\n");

    for(int i = 0; i< qualityList.length;i++)
    {
      if(qualityList[i].contains("x1080"))
      {
        linksMap["1080"] = qualityList[i+1];
      }
      else if(qualityList[i].contains("x720"))
      {
        linksMap["720"] = qualityList[i+1];
      }
      else if(qualityList[i].contains("x480"))
      {
        linksMap["480"] = qualityList[i+1];
      }
      else if(qualityList[i].contains("x360"))
      {
        linksMap["360"] = qualityList[i+1];
      }

    }
    return linksMap;
  }


  static Future<Map<String,Map<String,String>>> getAbysscdnHihihaha1M3U8Links(String orginalUrl,String serverName) async
  {
    Map<String,Map<String,String>> map = Map();
    Map<String,String> abyssQualityCdn = {"sd":"","hd":"www","fullHd":"whw"};
    dom.Document playerDocument = await WebUtils.getDomFromURL_Get(orginalUrl!);
    List<dom.Element> scriptList = playerDocument.querySelectorAll("script");
    String? javascript = scriptList.where((element) => element.text.contains("new PLAYER(atob(")).first.text;
    String encodedBase64 = LocalUtils.getStringBetweenTwoStrings("new PLAYER(atob(\"", "\"));", javascript);
    String decodedBase64 = String.fromCharCodes(base64Decode(encodedBase64));
    HDMovie2VideoDetail hdMovie2VideoDetail = HDMovie2VideoDetail.fromJson(jsonDecode(decodedBase64));

    Map<String,String> map2 = Map();
    if (hdMovie2VideoDetail.sources!.isNotEmpty) {
      for(String qualitySource in hdMovie2VideoDetail.sources!)
          {
            String? q_prefix = abyssQualityCdn[qualitySource];
            String fullM3U8Url = "https://${hdMovie2VideoDetail.domain}/${q_prefix}${hdMovie2VideoDetail.id}";
            map2[qualitySource.toUpperCase()] = fullM3U8Url;

          }
    } else {
      for(String key in abyssQualityCdn.keys)
        {
          String fullM3U8Url = "https://${hdMovie2VideoDetail.domain}/${abyssQualityCdn[key]}${hdMovie2VideoDetail.id}";
          map2[key.toUpperCase()] = fullM3U8Url;
        }
    }

    map[serverName + "_headers"] = {"Referer":orginalUrl};
    map[serverName] = map2;
    return map;
  }

  static Future<Map<String,Map<String,String>>> getAkamaicdnM3U8Links(String url,{Map<String,String>? header}) async
  {
    Map<String,Map<String,String>> map = Map();
    String  AKAMAICDN_SERVER_URL = "https://akamaicdn.life/";
    dom.Document pageDocument = await WebUtils.getDomFromURL_Get(url,headers: header);
    String javascript = pageDocument.querySelectorAll("script").where((element) => element.text.contains("sniff")).first.text;
    List<String> idsList = LocalUtils.getStringBetweenTwoStrings("sniff(", ");", javascript).split(",");
    String m3u8Url = AKAMAICDN_SERVER_URL + "m3u8/${(idsList[1]).replaceAll("\"","")}/${idsList[2].replaceAll("\"","")}/master.txt?s=1&cache=1";
    String? m3u8QualityLinksResponse = await WebUtils.makeGetRequest(m3u8Url);
    List<String> m3u8QualityUrls = m3u8QualityLinksResponse!.split("\n");
    Map<String,String> qualityMap = Map();
    for(int i = 0;i< m3u8QualityUrls.length;i++)
    {
      if(m3u8QualityUrls[i].contains("akamaicdn"))
      {
        if(m3u8QualityUrls[i -1].contains("1080"))
        {
          qualityMap["1080"] = m3u8QualityUrls[i];
        }
        else if(m3u8QualityUrls[i -1].contains("720"))
        {
          qualityMap["720"] = m3u8QualityUrls[i];
        }
        else if(m3u8QualityUrls[i -1].contains("360"))
        {
          qualityMap["360"] = m3u8QualityUrls[i];
        }
      }
    }

    map[VideoHosterEnum.Akamaicdn.name] = qualityMap;
    map[VideoHosterEnum.Akamaicdn.name + "_headers"] = {"Referer":AKAMAICDN_SERVER_URL,"Accept" : "*/*","User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"};

    return map;
  }

  //ok.ru
  static Future<Map<String,Map<String,String>>> getOkRuM3U8Links(String url) async
  {
    Map<String,Map<String,String>> map = Map();
    final TWDOWN_SEARCH_SERVER_URL = "https://twdown.online/search?url=";
    final TWDOWN_DOWNLOAD_SERVER_URL = "https://downloader.twdown.online/load_url?";
    String cookie = "XSRF-TOKEN=eyJpdiI6Im1oNEcyOEpndGhyTW9JNHA5ZGhLTkE9PSIsInZhbHVlIjoiQkRYd2loWVh1c3YzN280VkwwTDdPbnpJVWlWaWJNOVplK0MydmNCM0hmXC9RQlRvNVlaazk2c1ZNc25lV2FMRlgiLCJtYWMiOiI1OWIzYjdjOWI2MGZhYzQ4NGYwZTg4Y2RlYjFlYWI4MzFiNmI4NGMzNTMwMTc3MTk0ZDU3Mjk2YTA2NzNhYTlkIn0%3D; s_id=QVH0JEya2VJApNM1ASB0lJiOScfhGI7LYPMZYvwz";
    String finalURl = TWDOWN_SEARCH_SERVER_URL + url;
    dom.Document pageDocument = await WebUtils.getDomFromURL_Get(finalURl,headers: {"Cookie" : cookie} );
    List<dom.Element> trElements = pageDocument.querySelectorAll("tbody tr");
    Map<String,String> okruQualityLinksMap = Map();
    for(dom.Element tdElement in trElements)
    {
      List<dom.Element> tdElementList = tdElement.querySelectorAll("td");
      if (tdElementList[0].text.contains("x")) {

        try {
          String? url = tdElementList[2].querySelector("a")!.attributes["href"];
          String? finalUrl = url!.split("#")[1];
          String downloadURL = TWDOWN_DOWNLOAD_SERVER_URL + finalUrl;
          String? finalDownloadURL = await WebUtils.makeGetRequest(downloadURL);
          okruQualityLinksMap[tdElementList[0].text] = finalDownloadURL!;
        } catch (e) {
          print(e);
        }
      }
    }

    map[VideoHosterEnum.OkRu.name + "_headers"] = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"};
    map[VideoHosterEnum.OkRu.name] = okruQualityLinksMap;
    return map;
  }

  static Future<Map<String,String>> getUpCloudMegaCloudM3U8Links(String url,String extension,Map<String,String>? headers) async
  {
    Map<String,String> qualityMap = Map();
    /*String finalCloudUrl = "https://megacloud.tv/embed-1/ajax/e-1/getSources?id=" + serverId;
    Map<String,String> headers = {"X-Requested-With":"XMLHttpRequest"};*/
    WebViewUtils webViewUtils = WebViewUtils();
    String finalUrl = await webViewUtils.loadUrlInWebView(url,extension,header: headers);
    webViewUtils.disposeWebView();
    /*String? response = await WebUtils.makeGetRequest(finalCloudUrl,headers:headers);
    String m3u8Link = jsonDecode(response!)["sources"][0]["file"];*/
    String? qualityLinks = await WebUtils.makeGetRequest(finalUrl);
    List<String> qualityList = qualityLinks!.split("\n");

    for(String link in qualityList)
    {
      if(link.contains("m3u8"))
      {
        if(link.contains("1080"))
        {
          qualityMap["1080"] = link;
        }
        else if(link.contains("720"))
        {
          qualityMap["720"] = link;
        }
        else if(link.contains("480"))
        {
          qualityMap["480"] = link;
        }
        else if(link.contains("360"))
        {
          qualityMap["360"] = link;
        }
      }
    }
    return qualityMap;
  }

  static Future<String?> getM3U8UrlFromVidHidePre(String embededUrl,String title,{bool isVideotoEmbededAllowed = false, Map<String,String>? headers}) async
  {
    if (isVideotoEmbededAllowed) {
      embededUrl = embededUrl.replaceAll("/f/", "/embed/");
    }
    try {
      dom.Document document = await WebUtils.getDomFromURL_Get(embededUrl,headers: headers);
      List<dom.Element> list = document.querySelectorAll("script[type=\"text/javascript\"]");
      String javaScriptText = list.where((element) => element.text.contains("sources: [{file:\"")).first.text;
      String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]," , javaScriptText);
      //Get.to(VideoPlayerScreen(m3u8Url,title!,));
      LocalUtils.startVideoPlayer(m3u8Url, title);
      /*ExternalVideoPlayerLauncher.launchMxPlayer(
              m3u8Url!, MIME.applicationVndAppleMpegurl, {
            "title": title,
          });*/
    } catch (e) {
      LoaderDialog.stopLoaderDialog();
      Fluttertoast.showToast(msg: "Video has bee removed.Try another server...",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }

  }


  static Future<String> getPlaym4UM3U8Links(String embedUrl,{Map<String, String>? headers}) async
  {
    WebViewUtils webViewUtils = WebViewUtils();
    String? finalUrl = await webViewUtils.loadUrlInWebView(embedUrl,".m3u8",header: headers);
    webViewUtils.disposeWebView();
    return finalUrl;
  }

  static Future<Map<String,String>> getMinoplresM3U8Links (String embedUrl,{Map<String,String>? header,bool isWithServerName = true}) async
  {
    Map<String,String> map = Map();
    final String MINOPLRES_SERVER_URL = "https://minoplres.xyz";
    dom.Document document = await WebUtils.getDomFromURL_Get(embedUrl!,headers: header);
    List<dom.Element> listJavascript = document.querySelectorAll("script[type=\"text/javascript\"]");
    String javaScriptText = listJavascript.where((element) => element.text.contains("sources: [{file:\"")).first.text;
    String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]" , javaScriptText);
    String urlSetLink = "";
    if(!m3u8Url.contains(",l,h,.urlset"))
    {
      urlSetLink = m3u8Url.replaceAll("_l", "_,l,h,.urlset");
      urlSetLink = m3u8Url.replaceAll("_h", "_,l,h,.urlset");
    }
    else
    {
      urlSetLink = m3u8Url;
    }
    String? response = await WebUtils.makeGetRequest(urlSetLink,headers: {"Referer":MINOPLRES_SERVER_URL});
    if (!response!.contains("Not Found")) {
      List<String> m3u8UrlList = response!.split("\n");
      List<String> qualityUrlList = [];
      for(String url in m3u8UrlList)
      {

        if(url.contains("_l/") && url.contains("m3u8"))
        {
          if(isWithServerName)
            {
              map["Minoplres(${VideoQualityEnum.Low.name})"] = url;
            }
          else
            {
              map[VideoQualityEnum.Low.name] = url;
            }

        }
        else if(url.contains("_h/") && url.contains("m3u8"))
        {
          if(isWithServerName)
          {
            map["Minoplres(${VideoQualityEnum.High.name})"] = url;
          }
          else
          {
            map[VideoQualityEnum.High.name] = url;
          }
        }
        else if(url.contains("_o/") && url.contains("m3u8"))
        {
          if(isWithServerName)
          {
            map["Minoplres(${VideoQualityEnum.Orginal.name})"] = url;
          }
          else
          {
            map[VideoQualityEnum.Orginal.name] = url;
          }
        }
      }
    } else {
      if(isWithServerName)
      {
        map["Minoplres(${VideoQualityEnum.Orginal.name})"] = m3u8Url;
      }
      else
      {
        map[VideoQualityEnum.Orginal.name] = m3u8Url;
      }
    }

    return map;
  }

  static Future<dynamic> getVidSrcToM3U8Links (String embedUrl,{Map<String,String>? header,bool isWithServerName = true}) async
  {
    Map<String,String> map = Map();
    Map<String,Map<String,String>> map2 = Map();
    final String VIDSRCTO_SERVER_URL = "https://vidsrc.to";
    dom.Document vidSrcToDocument = await WebUtils.getDomFromURL_Get(embedUrl!);
    String? mediaId = vidSrcToDocument.querySelector("ul.episodes li a")!.attributes["data-id"];
    String finalSourceUrl = VIDSRCTO_SERVER_URL + "/ajax/embed/episode/$mediaId/sources";
    String? sourceResponse = await WebUtils.makeGetRequest(finalSourceUrl);
    VidSrcToSourceResponse vidSrcToSourceResponse = VidSrcToSourceResponse.fromJson(jsonDecode(sourceResponse!));

    for (VidSrcToSource vidSrcToSource in vidSrcToSourceResponse.result!)
    {
      String finalSourceUrlLink = VIDSRCTO_SERVER_URL + "/ajax/embed/source/${vidSrcToSource.id}";
      String? urlResponse = await WebUtils.makeGetRequest(finalSourceUrlLink);
      VidSrcToUrlResponse vidSrcToUrlResponse = VidSrcToUrlResponse.fromJson(jsonDecode(urlResponse!));
      String decodedUrl = await kotlinMethodChannel.invokeMethod("getDecodedVidSrcUrl",{"encString":vidSrcToUrlResponse.result!.url,});
      if(vidSrcToSource.title == "Vidplay")
      {
        Map<String,String> vidPlayMap =  await VideoHostProviderUtils.getVidPlayMyCloudM3U8Links(decodedUrl, VideoHosterEnum.VidPlay,isWithServerName: isWithServerName);
        if(isWithServerName)
          {
            map.addAll(vidPlayMap);
          }
        else
          {
            map2[VideoHosterEnum.VidPlay.name] = vidPlayMap;
          }
      }
      else if(vidSrcToSource.title == "Filemoon")
      {
        Map<String,String> fileMoonMap = Map();
        String? finalEmbedUrl = decodedUrl.split("?")[0];
        await VideoHostProviderUtils.getM3U8UrlfromFileMoon(finalEmbedUrl, "",canReturn: (value){
          if(isWithServerName)
            {
              fileMoonMap[VideoHosterEnum.FileMoon.name + "(HD)"] = value;
              map.addAll(fileMoonMap);
            }
          else
            {
              fileMoonMap["HD"] = value;
              map2[VideoHosterEnum.FileMoon.name] = fileMoonMap;
            }

        });

      }
    }
    if(isWithServerName) {
      return map;
    }
    else
      {
        return map2;
      }
  }

  static Future<Map<String,String>> getVidSrcToSingleM3U8Links(String url,String extension, {Map<String, String>? headers}) async
  {
    Map<String,String> qualityMap = Map();
    /*String finalCloudUrl = "https://megacloud.tv/embed-1/ajax/e-1/getSources?id=" + serverId;
    Map<String,String> headers = {"X-Requested-With":"XMLHttpRequest"};*/
    WebViewUtils webViewUtils = WebViewUtils();
    String finalUrl = await webViewUtils.loadUrlInWebView(url,extension,header: headers);
    webViewUtils.disposeWebView();
    /*String? response = await WebUtils.makeGetRequest(finalCloudUrl,headers:headers);
    String m3u8Link = jsonDecode(response!)["sources"][0]["file"];*/
    String? qualityLink = await WebUtils.makeGetRequest(finalUrl);
    List<String> qualityList = qualityLink!.split("\n");

    for(int i = 0;i<qualityList.length;i++)
    {
        if(qualityList[i].contains("x1080"))
        {
          qualityMap["1080"] = LocalUtils.getStringBeforString("list", finalUrl) + qualityList[i+1];
        }
        else if(qualityList[i].contains("x720"))
        {
          qualityMap["720"] = LocalUtils.getStringBeforString("list", finalUrl) + qualityList[i+1];
        }
        else if(qualityList[i].contains("x480"))
        {
          qualityMap["480"] = LocalUtils.getStringBeforString("list", finalUrl) + qualityList[i+1];
        }
        else if(qualityList[i].contains("x360"))
        {
          qualityMap["360"] = LocalUtils.getStringBeforString("list", finalUrl) + qualityList[i+1];
        }

    }
    return qualityMap;
  }

  static Future<Map<String,String>> getNetuM3U8Link (String url) async
  {
    Map<String,String> map = Map();
    WebViewUtils webViewUtils = WebViewUtils();
    url = url.replaceAll("/e/", "/f/");
    //String? oUrl = await WebUtils.getOriginalUrl(url);
    String fUrl = await webViewUtils.loadUrlInWebView(url!, "get_md5.php");
    return map;
  }


}