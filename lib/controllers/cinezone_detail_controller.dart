
import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:Movieverse/models/cinezone/cinezone_cover.dart';
import 'package:Movieverse/models/cinezone/cinezone_detail.dart';

enum Vrf
{
  Encrypt,
  Decrypt
}

class CineZoneDetailController extends GetxController
{
  final CINEZONE_EPISODE_LIST_AJAX_URL = "https://cinezone.to/ajax/episode/list/";
  final CINEZONE_SERVER_LIST_AJAX_URL = "https://cinezone.to/ajax/server/list/";
  final CINEZONE_SERVER_AJAX_URL = "https://cinezone.to/ajax/server/";
  late dom.Document pageDocument;
  late String mediaId;
  RxString selectedEpisode = "".obs;
  RxString selectedSeason = "".obs;
  MethodChannel kotlinMethodChannel = MethodChannel("KOTLIN_CHANNEL");
  Future<CineZoneDetail> getMovieDetail (CineZoneCover cineZoneCover) async
  {
     pageDocument = await WebUtils.getDomFromURL_Get(cineZoneCover.url!);
     String genre = "N/A", ratings = "N/A", releasedDate = "N/A", country = "N/A", actors = "N/A", duration = "N/A", description = "N/A", production = "N/A", director = "N/A", type = "N/A", year = "N/A", serverId = "N/A";
     mediaId = pageDocument.querySelector(".container.watch-wrap")!.attributes["data-id"]!;
     dom.Element? bodyElement = pageDocument.querySelector(".rightSide .body");

     List<dom.Element> statusList = bodyElement!.querySelectorAll(".status span");
     ratings = statusList[0].text;
     year = statusList[2].text;
     duration = statusList[3].text;

     description = bodyElement!.querySelector(".description")!.text;

     List<dom.Element> metaElementList = bodyElement!.querySelectorAll(".meta div").where((element) => element.nodes.length > 1).toList();

     for(dom.Element metaElement in metaElementList)
       {
         String? key = metaElement.querySelector("div")!.text;
         switch (key)
         {
           case "Type:":
             type = metaElement.querySelector("span a")!.text;
           case "Country:":
             country = metaElement.querySelector("span")!.text;
             //country = metaElement.querySelectorAll("span a").fold("", (previousValue, element) => previousValue + element.text + " ");
           case "Genre:":
             genre = metaElement.querySelector("span")!.text;
             //genre = metaElement.querySelectorAll("span a").fold("", (previousValue, element) => previousValue + element.text + " ");
           case "Release:":
             releasedDate = metaElement.querySelector("span")!.text;
           case "Director:":
             director =  metaElement.querySelectorAll("span a span").fold("", (previousValue, element) => previousValue + element.text + " ");
           case "Production:":
             production = metaElement.querySelector("span")!.text;
             //production = metaElement.querySelectorAll("span a").fold("", (previousValue, element) => previousValue + element.text + " ");
           case "Cast:":
             actors = metaElement.querySelector("span")!.text;
             //actors = metaElement.querySelectorAll("span a").fold("", (previousValue, element) => previousValue + element.text + " ");

         }
       }
     String? finalEpisodeUrl = CINEZONE_EPISODE_LIST_AJAX_URL + mediaId! + "?vrf=" + (await getVrf(mediaId, Vrf.Encrypt));
     String? response = await WebUtils.makeGetRequest(finalEpisodeUrl);
     var json = jsonDecode(response!);
     dom.Document episodeDocument = await WebUtils.getDomfromHtml(json["result"]!);
     Map<String,Map<String,String>> episodesSeasonMap = Map();
     if(cineZoneCover.url!.contains("/tv/"))
       {
         episodesSeasonMap = getSeasonEpisodes(episodeDocument);
         selectedSeason.value = episodesSeasonMap.keys.first;
         selectedEpisode.value = episodesSeasonMap[episodesSeasonMap.keys.first]!.keys.first;
       }
     else
       {

         serverId = episodeDocument.querySelector(".episodes li a")!.attributes["data-id"]!;
       }

     return CineZoneDetail(releasedDate: releasedDate,ratings: ratings,production: production,country: country,actors: actors,coverUrl: cineZoneCover.imageURL,description: description,genre: genre,duration: duration,url: cineZoneCover.url,title: cineZoneCover.title,tag1: cineZoneCover.tag1,tag2: cineZoneCover.tag2,director: director,type: type,year: year,serverId: serverId,episodeSeasonMap: episodesSeasonMap);
  }

  Future<Map<String,Map<String,String>>> getVideoLinks (String? serverId, {bool isTvShow = false}) async
  {
    Map<String,Map<String,String>> map = Map();
    String? finalEpisodeUrl = CINEZONE_SERVER_LIST_AJAX_URL + serverId! + "?vrf=" + (await getVrf(serverId, Vrf.Encrypt));
    String? response = await WebUtils.makeGetRequest(finalEpisodeUrl);
    var json = jsonDecode(response!);
    dom.Document serverDocument = await WebUtils.getDomfromHtml(json["result"]!);
    List<dom.Element> serverList = serverDocument.querySelectorAll(".server");
    for (dom.Element serverElement in serverList )
      {
        String? serverName = serverElement.querySelector("button span")!.text;
        String? serverLinkId = serverElement.attributes["data-link-id"];
        String? finalServerUrl = CINEZONE_SERVER_AJAX_URL + serverLinkId! + "?vrf=" + (await getVrf(serverLinkId, Vrf.Encrypt));
        String? response = await WebUtils.makeGetRequest(finalServerUrl);
        var json = jsonDecode(response!);
        String finalDecryptedUrl = await getVrf(json["result"]["url"], Vrf.Decrypt);
        print(finalDecryptedUrl);
        switch(serverName)
        {
          case "Vidplay":
            Map<String,Map<String,String>> vidPlayMap = Map();
            vidPlayMap[VideoHosterEnum.VidPlay.name] = await VideoHostProviderUtils.getVidPlayMyCloudM3U8Links(finalDecryptedUrl,VideoHosterEnum.VidPlay);
            map.addAll(vidPlayMap);
          case "MyCloud":
            Map<String,Map<String,String>> myCloudMap = Map();
            myCloudMap[VideoHosterEnum.MyCloud.name] = await VideoHostProviderUtils.getVidPlayMyCloudM3U8Links(finalDecryptedUrl,VideoHosterEnum.MyCloud);
            map.addAll(myCloudMap);

          case "Filemoon":
          Map<String,Map<String,String>> fileMoonMap = Map();
          String? finalEmbedUrl = finalDecryptedUrl.split("?")[0];
          await VideoHostProviderUtils.getM3U8UrlfromFileMoon(finalEmbedUrl, "",canReturn: (value){
            Map<String,String> linkMap = Map();
            linkMap["HD"] = value;
            fileMoonMap[VideoHosterEnum.FileMoon.name] = linkMap;
            map.addAll(fileMoonMap);
          });

          case "F2Cloud":
            Map<String,Map<String,String>> linkMap = Map();
            Map<String,String> qualityMap = await VideoHostProviderUtils.getVidSrcToSingleM3U8Links(finalDecryptedUrl, ".m3u8");
            linkMap[VideoHosterEnum.F2Cloud.name] = qualityMap;
            map.addAll(linkMap);
          case "MegaCloud":

            Map<String,Map<String,String>> linkMap = Map();
            Map<String,String> qualityMap = await VideoHostProviderUtils.getVidSrcToSingleM3U8Links(finalDecryptedUrl, ".m3u8");
            linkMap[VideoHosterEnum.Megacloud.name] = qualityMap;
            map.addAll(linkMap);

        }
      }
    return map;
  }

  Map<String,Map<String,String>> getSeasonEpisodes(dom.Document document)
  {
    Map<String,Map<String,String>> map = Map();
    List<dom.Element> seasonList = document.querySelectorAll(".episodes");
    for(dom.Element seasonElement in seasonList)
      {
        String seasonNo = seasonElement!.attributes["data-season"]!;
        List<dom.Element> episodesList = seasonElement.querySelectorAll("li");
        Map<String,String> episodeMap = Map();
        for (dom.Element episodeElement in episodesList)
          {
            String? episodeName = episodeElement.querySelector("p")!.text + " - " + LocalUtils.convertHtmlToUnescape(episodeElement.querySelector("span")!.text);
            episodeMap[episodeName] = episodeElement.querySelector("a")!.attributes["data-id"]!;
          }
        map[seasonNo] = episodeMap;
      }
    return map;
  }

  Future<String> getVrf (String data,Vrf vrf) async
  {
    if(vrf == Vrf.Decrypt)
      {
        String decryptedData = await kotlinMethodChannel.invokeMethod("getVrfDecryptedData",{"data":data});
        return decryptedData;
      }
    else if (vrf == Vrf.Encrypt)
      {
        String encryptedData = await kotlinMethodChannel.invokeMethod("getVrfEncryptedData",{"data":data});
        return encryptedData;
      }
    return "";
  }




 String? getServerName(String? id)
  {
    switch(id)
    {
      case "41":
        return "Vidplay";
      case "28":
        return "MyCloud";
      case "45":
        return "Filemoon";
    }
  }
}