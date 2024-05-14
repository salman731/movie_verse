

import 'dart:async';
import 'dart:convert';

import 'package:Movieverse/models/goku/goku_cover.dart';
import 'package:Movieverse/models/goku/goku_detail.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:Movieverse/utils/web_view_utils.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class GokuDetailController extends GetxController
{
  final String GOKU_BASE_URL = "https://goku.sx/";
  final String GOKU_MOVIE_EPISODE_SERVER_URL = "https://goku.sx/ajax/movie/episode/servers/";
  final String GOKU_MOVIE_EPISODE_SOURCES_URL = "https://goku.sx/ajax/movie/episode/server/sources/";
  late dom.Document pageDocument;
  late String mediaDataId;


  Future<GokuDetail> getMovieSerieDetail (GokuCover gokuCover) async
  {
     pageDocument  = await WebUtils.getDomFromURL_Get(gokuCover.url!);

     String? genre = "N/A" ,country = "N/A" ,actors = "N/A" ,duration = "N/A" ,description = "N/A" ,production = "N/A" ,serverId = "";
     
     String? serverUrl = pageDocument.querySelector("meta[property=\"og:url\"]")!.attributes["content"];

     List<String> list = serverUrl!.split("/");

     serverId = list[list.length - 1];

     description = pageDocument.querySelector(".movie-detail .is-description .text-cut")!.text;

     List<dom.Element> detailElementList = pageDocument.querySelectorAll(".is-sub > div");

     for(dom.Element detailElement in detailElementList)
       {
          String? key = detailElement.querySelector(".name")!.text;
          String? value = detailElement.querySelector(".value")!.text;
          value = LocalUtils.removeExtraWhiteSpaceBetweenWords(value.replaceAll("\n", "").trim());
          switch (key)
          {
            case "Genres:":
              genre = value;
            case "Cast:":
              actors = value;
            case "Production:":
              production = value;
            case "Country:":
              country = value;
            case "Duration:":
              duration = value;
          }
       }

     return GokuDetail(url: gokuCover.url,tag2: gokuCover.tag2,tag1: gokuCover.tag1,title: gokuCover.title,duration: duration,actors: actors,country: country,coverUrl: gokuCover.imageURL,description: description,genre: genre,production: production,serverId: serverId);

  }

  Future<Map<String,Map<String,String>>> getVideoServerLinks (String serverId,bool isTvShow) async
  {
    Map<String,Map<String,String>> map = Map();
    final serverUrl = GOKU_MOVIE_EPISODE_SERVER_URL + serverId;
    dom.Document serverDocument = await WebUtils.getDomFromURL_Get(serverUrl);

    List<dom.Element> serverElementList = serverDocument.querySelectorAll(".dropdown-menu.dropdown-primary a");

    for (dom.Element serverElement in serverElementList)
      {
        String? serverSourceId = serverElement.attributes["data-id"];
        String? serverName = serverElement!.text;
        if(serverName == "UpCloud" || serverName == "Vidcloud")
          {
            Map<String,String> qualityMap = Map();
            final serverSourceUrl = GOKU_MOVIE_EPISODE_SOURCES_URL + serverSourceId!;
            String? jsonResponse = await WebUtils.makeGetRequest(serverSourceUrl);
            var json = jsonDecode(jsonResponse!);
            String embedUrl = json["data"]["link"];
            WebViewUtils webViewUtils = WebViewUtils();
            Map<String,String> serverMap = await webViewUtils.loadUrlInWebView(embedUrl,"playlist.m3u8",serverName,header: {"Referer" : GOKU_BASE_URL});
            webViewUtils.disposeWebView();
            String? qualityLinks;
            if(serverName == "UpCloud")
              {
                qualityLinks =  await WebUtils.makeGetRequest(serverMap[serverName]!);
              }
            else
              {
                qualityLinks = await WebUtils.requestWithBadCertificate(serverMap[serverName]!);
              }
            List<String> qualityList = qualityLinks!.split("\n");

            for(int i = 0; i< qualityList.length;i++)
            {
                if(qualityList[i].contains("x1080"))
                {
                  qualityMap["1080"] = qualityList[i+1];
                }
                else if(qualityList[i].contains("x720"))
                {
                  qualityMap["720"] = qualityList[i+1];
                }
                else if(qualityList[i].contains("x480"))
                {
                  qualityMap["480"] = qualityList[i+1];
                }
                else if(qualityList[i].contains("x360"))
                {
                  qualityMap["360"] = qualityList[i+1];
                }

            }

            map[serverName] = qualityMap;

          }

      }

    return map;

  }
}