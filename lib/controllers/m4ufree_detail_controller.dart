

import 'dart:convert';

import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/models/m4u_free/m4ufree_cover.dart';
import 'package:Movieverse/models/m4u_free/m4ufree_detail.dart';
import 'package:Movieverse/models/m4u_free/m4ufree_episode.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class M4UFreeDetailController extends GetxController
{
  late dom.Document pageDocument;
  String M4UFreeAjaxURL = "https://ww2.m4ufree.com/ajax";
  String M4UFreeAjaxTVURL = "https://ww2.m4ufree.com/ajaxtv";
  late String cookieStr;
  Rx<M4UFreeEpisode> selectedEpisode = M4UFreeEpisode().obs;
  bool isTvShow  = false;
  Future<M4UFreeDetail> getMovieDetail (M4UFreeCover m4uFreeCover) async
  {
    pageDocument = await WebUtils.getDomFromURL_Get(m4uFreeCover.url!,onCookie: (cookie) {
      String csrf_token = LocalUtils.getStringBetweenTwoStrings("XSRF-TOKEN=", ";", cookie!);
      String laravel_session = LocalUtils.getStringBetweenTwoStrings("laravel_session=", ";", cookie!);
      cookieStr = "XSRF-TOKEN=${csrf_token}; laravel_session=${laravel_session}";
    } );

    String? genre = "N/A", director = "N/A", country = "N/A", actors = "N/A", runtime = "N/A", description = "N/A", released = "N/A", quality = "N/A";

    List<dom.Element> infoElementList = pageDocument.querySelectorAll(".iteminfo .row .col-12.col-sm-6.pl-4.pb-2.pt-sm-4 .mvdt");

    description = pageDocument.querySelector("pre")!.text.replaceAll("Storyline:", "");
    for (dom.Element infoElement in infoElementList)
      {
        if(infoElement.nodes.length == 4)
          {
            infoElement.nodes!.removeWhere((e)=> e.text!.isEmpty);
          }
        dom.NodeList infoNodeList = infoElement.nodes;
        String? key = infoNodeList[1]!.text!.trim();
        String? value = infoNodeList[2]!.text!.trim();
        switch(key)
         {
          case "Quality:":
            quality = value;
          case "Director:":
            director = value;
          case "Genre:":
            genre = value;
          case "Quality:":
            quality = value;
          case "Country:":
            country = value;
          case "Runtime:":
            runtime = value;
          case "Released:":
            released = value;
          case "Starring:":
            actors = LocalUtils.removeExtraWhiteSpaceBetweenWords(value);
        }
      }

    List<M4UFreeEpisode> eList = [];
    if(m4uFreeCover.url!.contains("tvshow"))
      {
        isTvShow = true;
        eList = getTvShowEpisodeList();
        selectedEpisode.value = eList.first;
      }
    else
      {
        isTvShow = false;
      }

    return M4UFreeDetail(url: m4uFreeCover.url,title: m4uFreeCover.title,actors: actors,country: country,coverUrl: m4uFreeCover.imageURL,description: description,director: director,genre: genre,quality: quality,released: released,runtime: runtime,episodeList: eList);

  }


  Future<Map<String,Map<String,String>>> getVideoServerLinks(String referer) async
  {
    Map<String,Map<String,String>> linksMap = Map();
    String? csrfToken = pageDocument.querySelector("meta[name=\"csrf-token\"]")!.attributes["content"];
    List<dom.Element> serverElementList = [];
    if(isTvShow)
      {
        var map =  {"idepisode":selectedEpisode.value.id,"_token":csrfToken};
        String? response = await WebUtils.makePostRequest(M4UFreeAjaxTVURL, map,headers: {"X-Requested-With":"XMLHttpRequest","Cookie":cookieStr,"Referer":referer});
        dom.Document? episodeDocument;
        episodeDocument = WebUtils.getDomfromHtml(response);
        serverElementList = episodeDocument.querySelectorAll(".le-server");
      }
    else
      {
        serverElementList = pageDocument.querySelectorAll(".le-server");
      }

    for (dom.Element serverElement in  serverElementList)
      {
         String? hashValue = serverElement!.querySelector("span")!.attributes["data"];
         var map =  {"m4u":hashValue,"_token":csrfToken};
         String? response = await WebUtils.makePostRequest(M4UFreeAjaxURL, map,headers: {"X-Requested-With":"XMLHttpRequest","Cookie":cookieStr,"Referer":referer});
         dom.Document iframeDocument = await WebUtils.getDomfromHtml(response!);
         dom.Element? iframeElement = iframeDocument.querySelector("iframe");
         if(iframeElement != null)
           {
              String? iframeSrc = iframeElement.attributes["src"];

              if(iframeSrc!.contains("playm4u.xyz"))
                {
                  try {
                    Map<String,String> serverMap = Map();
                    String finalUrl = await VideoHostProviderUtils.getPlaym4UM3U8Links(iframeSrc,headers: {"Referer":"https://ww2.m4ufree.com"});
                    serverMap["HD"] = finalUrl;
                    linksMap[VideoHosterEnum.Playm4U.name] = serverMap;
                  } catch (e) {
                    print(e);
                  }
                }
              else if(iframeSrc.contains("hihihaha1.xyz"))
                {
                  try {
                    Map<String,Map<String,String>> serverMap = Map();
                    serverMap = await VideoHostProviderUtils.getAbysscdnHihihaha1M3U8Links(iframeSrc, VideoHosterEnum.Hihihaha1.name);
                    linksMap.addAll(serverMap);
                  } catch (e) {
                    print(e);
                  }
                }
              else if (iframeSrc.contains("vidsrc.to"))
                {
                  try {
                    Map<String,Map<String,String>> serverMap = Map();
                    serverMap = await VideoHostProviderUtils.getVidSrcToM3U8Links(iframeSrc!,isWithServerName: false);
                    linksMap.addAll(serverMap);
                  } catch (e) {
                    print(e);
                  }
                }

           }
         else
           {
             String? txt = iframeDocument.querySelector("#myElement")!.text;
             if(txt == "Loading the player...")
               {
                  String? javaScriptText = iframeDocument.querySelectorAll("script").where((value)=>value.text.contains("playerInstance")).first.text;
                  String? directUrl = LocalUtils.getStringBetweenTwoStrings("file: \"", "\",", javaScriptText);
                  linksMap.addAll({"Direct Link": {"HD":directUrl}});
               }
           }
      }

    return linksMap;
  }


  List<M4UFreeEpisode> getTvShowEpisodeList ()
  {
    List<M4UFreeEpisode> episodeList = [];

    List<dom.Element> episodeElementList = pageDocument.querySelectorAll("p .episode");

    for(dom.Element episodeElement in episodeElementList)
      {
         String? title = episodeElement.text;
         String? id = episodeElement.attributes["idepisode"];
         episodeList.add(M4UFreeEpisode(id: id,title: title));
      }

    return episodeList;

  }

}