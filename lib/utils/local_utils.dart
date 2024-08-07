

import 'dart:convert';
import 'dart:math';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/screens/video_player/video_player_screen.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:html_unescape/html_unescape.dart';

class LocalUtils
{
  static String getUpMoviesSearchURL(String movieName,{bool isLoadMore = false,int page = 1})
  {
    movieName = movieName.trim();

    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
      {
        if(movieName[i] == " ")
          {
            queryMovieName.write("+");
          }
        else
          {
            queryMovieName.write(movieName[i]);
          }
      }
    String searchURL;
    if (!isLoadMore) {
       searchURL = "https://upmovies.net/search-movies/$queryMovieName.html";
    } else {
       searchURL = "https://upmovies.net/search-movies/$queryMovieName/page-${page}.html";
    }
    return searchURL;
  }

  static String getPrimeWireSearchURL (String movieName,int page,String hash)
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("+");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    return "https://www.primewire.tf/filter?ds=${hash}&page=${page}&s=${queryMovieName}";
  }

  static String getFilm1kSearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("+");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
      {
        return "https://www.film1k.com/page/${pageNo}?s=${queryMovieName}";
      }
    else
      {
        return "https://www.film1k.com/?s=${queryMovieName}";
      }

  }

  static String getPrMoviesSearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("+");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
    {
      return "https://prmovies.agency/page/${pageNo}?s=${queryMovieName}";
    }
    else
    {
      return "https://prmovies.agency/?s=${queryMovieName}";
    }

  }

  static String getWatchMoviesSearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("+");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
    {
      return "https://watch-movies.com.pk/page/${pageNo}?s=${queryMovieName}";
    }
    else
    {
      return "https://watch-movies.com.pk/?s=${queryMovieName}";
    }

  }
  static String getWatchSeriesSearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("-");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
    {
      return "https://watchseries.pe/search/${queryMovieName}?page=${pageNo}";
    }
    else
    {
      return "https://watchseries.pe/search/${queryMovieName}";
    }

  }

  static String getHdMovie2SearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("+");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
    {
      return "https://hdmovie2.my/page/${pageNo}?s=${queryMovieName}";
    }
    else
    {
      return "https://hdmovie2.my/?s=${queryMovieName}";
    }

  }

  static String getCineZoneSearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("+");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
    {
      return "https://cinezone.to/filter?keyword=${queryMovieName}&page=${pageNo}";
    }
    else
    {
      return "https://cinezone.to/filter?keyword=${queryMovieName}";
    }

  }

  static String getGokuSearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("+");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
    {
      return "https://goku.sx/search?keyword=${queryMovieName}&page=${pageNo}";
    }
    else
    {
      return "https://goku.sx/search?keyword=${queryMovieName}";
    }

  }

  static String getM4UFreeSearchUrl(String movieName,{int? pageNo,bool isLoadMore = false})
  {
    StringBuffer queryMovieName = StringBuffer();
    String encodedMovieName = Uri.encodeComponent(movieName);
    for(int i = 0;i<movieName.length;i++)
    {
      if(movieName[i] == " ")
      {
        queryMovieName.write("-");
      }
      else
      {
        queryMovieName.write(movieName[i]);
      }
    }
    if(isLoadMore)
    {
      return "https://ww2.m4ufree.com/search/${encodedMovieName}/page/${pageNo}";
    }
    else
    {
      return "https://ww2.m4ufree.com/search/${queryMovieName}.html";
    }

  }

  static Future<String> decodeUpMoviesIframeEmbedUrl(String pageUrl) async
  {
    dom.Document document = await WebUtils.getDomFromURL_Get(pageUrl);
    List<dom.Element> list = document.getElementsByClassName("player-iframe animation");
    String? encodedData = list[0].querySelector("script")!.text!;
    String encodedEmbededUrl = LocalUtils.getStringBetweenTwoStrings("document.write(Base64.decode(", "));", encodedData);
    String iframe = String.fromCharCodes(base64Decode(encodedEmbededUrl.replaceAll("\"", "")));
    dom.Document document2 = parser.parse(iframe);
    String iframeUrl = document2.querySelector("iframe")!.attributes["src"]!.replaceAll(":///", "://")!;
    return iframeUrl;
  }

 static String getStringBetweenTwoStrings(String start,String end,String str)
  {

    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);

    return str.substring(startIndex + start.length, endIndex); // brown fox jumps
  }

  static String getStringfromStartToEnd(String start,String str)
  {
    final startIndex = str.indexOf(start);

    return str.substring(startIndex, str.length-1);
  }

  static String getStringAfterStartStringToEnd(String start,String str)
  {
    final startIndex = str.indexOf(start);

    return str.substring(startIndex + start.length, str.length);
  }

  static String getStringBeforString(String end,String str)
  {
    final endIndex = str.indexOf(end);

    return str.substring(0, endIndex);
  }


  static String getDoodHashValue()
  {
    String a = '';
    String t = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    int n = t.length;
    for (int o = 0; o < 10; o++) {
      a += t[Random().nextInt(n)];
    }
    return a;
  }

  static void openAndPlayVideoWithMxPlayer_Android(String videoUrl,String title, {String mime = "application/mp4",Map<String,String> headers = const <String,String> {}}) async
  {
    MethodChannel intentMethodChannel = MethodChannel("KOTLIN_CHANNEL");
    intentMethodChannel.invokeMethod("openMxPlayer",{"videoUrl":videoUrl,"title":title,"headers":headers,"mime":mime});
  }

  static void showExceptionToast (String exception)
  {
    Fluttertoast.showToast(msg: exception,toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
  }


  static bool isStringDouble (String value)
  {
    try {
      double.parse(value);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static startVideoPlayer(String url,String title,{Map<String,String> headers = const <String, String>{}})
  {
    LoaderDialog.stopLoaderDialog();
    Get.to(VideoPlayerScreen(url,title!,headers: headers,));
  }
  
  static Future<String> getDecrptedTextHdMovie2(String encryptedText) async
  {
    String? key = await WebUtils.makeGetRequest("https://raw.githubusercontent.com/Sofie99/Resources/main/chillix_key.json");
    key = key!.replaceAll("\n", "").replaceAll("\"", "");
    MethodChannel intentMethodChannel = MethodChannel("KOTLIN_CHANNEL");
    return (await intentMethodChannel.invokeMethod("getEncryptedText",{"key":key,"encryptedText":encryptedText}));
  }

  static String removeExtraWhiteSpaceBetweenWords(String str)
  {
    final whitespaceRE = RegExp(r"(?! )\s+| \s+");
    return str.split(whitespaceRE).join(" ");
  }

  static String convertHtmlToUnescape (String txt)
  {
      var unescape = new HtmlUnescape();
      var text = unescape.convert(txt);
      return text;

  }
}