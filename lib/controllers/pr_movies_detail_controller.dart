

import 'dart:convert';

import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/enums/video_quality_enum.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_detail.dart';
import 'package:Movieverse/models/pr_movies/vid_src_to_source.dart';
import 'package:Movieverse/models/pr_movies/vid_src_to_source_response.dart';
import 'package:Movieverse/models/pr_movies/vid_src_to_url_response.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class PrMoviesDetailController extends GetxController {
  late dom.Document pageSource;
  late dom.Document episodeSource;
  final String PRMOVIES_SERVER_URL = "https://prmovies.rent";
  final String VIDPLAY_SERVER_URL = "https://vidsrc.to";
  final String VIDPLAY_KEY_URL = "https://raw.githubusercontent.com/KillerDogeEmpire/vidplay-keys/keys/keys.json";
  static bool isSeries = false;
  RxString selectedEpisode = "".obs;
  MethodChannel intentMethodChannel = MethodChannel("KOTLIN_CHANNEL");

  Future<PrMoviesDetail> getMovieDetail(PrMoviesCover prMoviesCover) async
  {
    pageSource = await WebUtils.getDomFromURL_Get(prMoviesCover.url!);
    String? genre = "", director = "", country = "", actors = "", runtime = "", description = "", released = "", languageQuality = "",ratings = "",tvStatus = "",studio ="",networks="";

    description = pageSource.querySelector(".desc .f-desc")!.text;

    List<dom.Element> leftElememts = pageSource.querySelectorAll(".mvic-info .mvici-left p");

    for(dom.Element element in leftElememts)
      {
        String? key = element.querySelector("strong")!.text.trim();

        switch(key)
         {
          case "Genre:":
            List<dom.Element> aList = element.querySelectorAll("a");
            genre = aList.fold<String>("", (previousValue, element) => previousValue + element.text + " ");
          case "Director:":
            director = element.querySelector("span a")!.text;
          case "Actors:":
            List<dom.Element> aList = element.querySelectorAll("a");
            actors = aList.fold<String>("", (previousValue, element) => previousValue + element.text + ", ");
          case "Country:":
            country = element.querySelector("a")!.text;

         }
      }

    List<dom.Element> rightElememts = pageSource.querySelectorAll(".mvic-info .mvici-right p");

    for(dom.Element element in rightElememts)
    {
      String? key = element.querySelector("strong")!.text.trim();

      switch(key)
      {
        case "Duration:":
          runtime = element.querySelector("span")!.text;
        case "TV Status:":
          tvStatus = element.querySelector("span")!.text;
        case "Quality:":
          languageQuality = element.querySelector("span")!.text;
        case "Release:":
          released = element.querySelector("a")!.text;
        case "IMDb:":
          ratings = element.querySelector("span")!.text;
        case "TMDb:":
          ratings = element.querySelector("span")!.text;
        case "Country:":
          country = element.querySelector("a")!.text;
        case "Networks:":
          networks = element.querySelector("a")!.text;
      }
    }

    return PrMoviesDetail(url: prMoviesCover.url,title: prMoviesCover.title,ratings: ratings,actors: actors,country: country,coverUrl: prMoviesCover.imageURL,description: description,genre: genre,director: director,languageQuality: languageQuality,released: released,runtime: runtime,tags: prMoviesCover.tag,studio: studio,networks: networks,tvStatus: tvStatus,episodeMap: getEpisodesServerPages());
  }

  Future<Map<String,String>> getServerPages({String? episodeUrl,bool isSeries = false}) async
  {
    Map<String,String> map = Map();
    List<dom.Element> list = [];
    if (!isSeries) {
      list = pageSource.querySelectorAll(".movieplay iframe");
    } else {
      episodeSource = await WebUtils.getDomFromURL_Get(episodeUrl!);
      list = episodeSource.querySelectorAll(".movieplay iframe");
    }
    //String? iframeSrc = list.where((element) => element.attributes["src"]!.contains("minoplres")).first.attributes["src"];
    for (dom.Element element  in list)
      {
        if(element.attributes["src"]!.contains("minoplres"))
          {
            Map<String,String> serverMap = await VideoHostProviderUtils.getMinoplresM3U8Links(element.attributes["src"]!, header:{"Referer":PRMOVIES_SERVER_URL}, );
            map.addAll(serverMap);
          }
        else if (element.attributes["src"]!.contains("vidsrc.to"))
          {
            Map<String,String> serverMap = await VideoHostProviderUtils.getVidSrcToM3U8Links(element.attributes["src"]!);
            map.addAll(serverMap);
          }
        else if (element.attributes["src"]!.contains("vidsrc.net"))
          {
            dom.Document vidSrcDocument = await WebUtils.getDomFromURL_Get(element.attributes["src"]!);
            List<dom.Element> serverList = vidSrcDocument.querySelectorAll(".serversList .server");
            Map<String,String> vidSrcNetMap = Map();
            for (dom.Element serverElement in serverList)
              {
                switch (serverElement!.text.trim())
                {
                  case "VidSrc PRO":
                    try {
                      dom.Document? rcpSrcStreamDocument = await fetchandVerifyRcp(serverElement.attributes["data-hash"]!);
                      if(rcpSrcStreamDocument != null)
                        {
                          String rcpJavascript = rcpSrcStreamDocument.querySelectorAll("script").where((element) => element.text.contains("Playerjs")).first.text;
                          String encodedUrl = LocalUtils.getStringBetweenTwoStrings("file:\"#9", "\"", rcpJavascript).replaceAll(RegExp(r'/@#@\S+?=='), "");
                          String decodedUrl = String.fromCharCodes(base64Decode(encodedUrl));
                          vidSrcNetMap[serverElement!.text.trim()] = decodedUrl;
                          map.addAll(vidSrcNetMap);
                        }
                    } catch (e) {
                      print(e);
                    }
                  case "Superembed":
                    /*dom.Document? rcpSrcStreamDocument = await fetchandVerifyRcp(serverElement.attributes["data-hash"]!);
                    if(rcpSrcStreamDocument != null)
                      {
                         String? javaScript = rcpSrcStreamDocument.querySelectorAll("script").where((element) => element.text.contains("streambucket.net/?play")).first.text;
                         String? streamBucketUrl = LocalUtils.getStringBetweenTwoStrings("btoa(\"","\");", javaScript);
                         String? token = Uri.parse(streamBucketUrl).queryParameters["play"];

                      }*/
                }
              }

          }
      }
    return map;
  }

  Map<String,String> getEpisodesServerPages() {
    List<dom.Element> list = pageSource.querySelectorAll(
        "#seasons .tvseason .les-content a");
    Map<String,String> episodeMap = Map();
    if(list != null && list.isNotEmpty)
      {
        isSeries = true;
        for(dom.Element element in list)
          {
            episodeMap[element.text!] = element.attributes["href"]!;
          }
        selectedEpisode.value = episodeMap.keys.first;
      }
    else
      {
        isSeries = false;
      }
  return episodeMap;
  }

  Future<dom.Document?> fetchandVerifyRcp(String dataHash) async
  {
    String rcpStreamLink = "https://vidsrc.stream/rcp/$dataHash";
    dom.Document? rcpDocument = await WebUtils.getDomFromURL_Get(rcpStreamLink,headers: {"Referer":"https://vidsrc.net/","User-Agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"});
    dom.Element? turnstileElement = rcpDocument.querySelector(".cf-turnstile");
    if(turnstileElement != null)
    {
      dynamic response = await verifyRcp(rcpStreamLink);
      if(response is dom.Document)
      {
        rcpDocument = response;
      }
      else if(response is bool && !response)
      {
        rcpDocument =  null;
      }
    }
    if(rcpDocument != null)
      {
        String? javaScriptStr = rcpDocument.querySelectorAll("script").where((element) => element.text.contains("player_iframe")).first.text;
        String rcpSrcStreamUrl = "https:${LocalUtils.getStringBetweenTwoStrings("src: '", "',", javaScriptStr)}";
        dom.Document rcpSrcStreamDocument = await WebUtils.getDomFromURL_Get(rcpSrcStreamUrl,headers: {"Referer":"https://vidsrc.net/"});
        return rcpSrcStreamDocument;
      }
    else
      {
        return null;
      }

  }

  Future<dynamic> verifyRcp (String rcpStreamLink) async
  {
    late dom.Document rcpDocument;
    var jsonBody = {
      "sitekey": "0x4AAAAAAATD6DukOTUdZEnE",
      "url": rcpStreamLink,
      "invisible": "true"
    };
    var responseJson;
    try {
      String? response = await WebUtils.makePostRequest("https://turn.seized.live/solve",jsonEncode(jsonBody),headers: {"Content-Type":"application/json"});
       responseJson = jsonDecode(response);
    } catch (e) {
      return false;
    }

    String? rcpVerrifyResponse = await WebUtils.makePostRequest("https://vidsrc.stream/rcp_verify",{"token":responseJson["token"]},headers: {"Content-Type": "application/x-www-form-urlencoded","Referer": rcpStreamLink,"X-Requested-With":"XMLHttpRequest","User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"});
    if(rcpVerrifyResponse == "1")
      {
        rcpDocument = await WebUtils.getDomFromURL_Get(rcpStreamLink,headers: {"Referer":"https://vidsrc.net/","User-Agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"});
        return rcpDocument;
      }
    else
      {
        return false;
      }
  }

}