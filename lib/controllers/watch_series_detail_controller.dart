
import 'dart:convert';

import 'package:Movieverse/models/watch_series/watch_series_cover.dart';
import 'package:Movieverse/models/watch_series/watch_series_detail.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class WatchSeriesDetailController extends GetxController
{
  late dom.Document pageDocument;
  late String mediaId;

  final String WATCHSERIES_AJAX_EPISODE_SERVER = "https://watchseries.pe/ajax/episode/list/";
  final String WATCHSERIES_AJAX_SOURCE_SERVER = "https://watchseries.pe/ajax/episode/sources/";
  final String MEGACLOUD_AJAX_SOURCE_SERVER = "https://megacloud.tv/embed-1/ajax/e-1/getSources?id=";


  Future<WatchSeriesDetail> getMovieDetail(WatchSeriesCover watchSeriesCover) async
  {
    pageDocument = await WebUtils.getDomFromURL_Get(watchSeriesCover.url!);
    String? genre = "N/A", ratings = "N/A", releasedDate = "N/A", country = "N/A", actors = "N/A", duration = "N/A", description = "N/A", production = "N/A", id = "";
    ratings = pageDocument.querySelector(".dp-i-stats .item.mr-2 button")!.text.replaceAll("IMDB: ", "");
    description = pageDocument.querySelector(".dp-i-c-right .description")!.text.trim();
    id = pageDocument.querySelector(".detail_page-watch")!.attributes["data-id"];
    mediaId = id!;
    List<dom.Element> rightleftElements = pageDocument.querySelectorAll(".dp-i-c-right .elements .row .col-sm-12");

    for (dom.Element element in rightleftElements)
      {
        List<dom.Element> rowLineElements = element.querySelectorAll(".row-line");

        for(dom.Element rowLineElement in rowLineElements)
          {
             String? key = rowLineElement.querySelector("span strong")!.text;

             switch (key.trim())
             {
               case "Released:":
                 releasedDate = rowLineElement!.text.replaceAll("Released:", "").replaceAll("\n", "").trim();
               case "Genre:":
                 List<dom.Element> list = rowLineElement.querySelectorAll("a");
                 if(list.length == 1)
                   {
                     genre = list.first.text;
                   }
                 else
                   {
                     genre = list.fold("", (previousValue, element) => "${previousValue!} ${element.text!} ");
                   }
               case "Casts:":
                 List<dom.Element> list = rowLineElement.querySelectorAll("a");
                 if(list.length == 1)
                 {
                   actors = list.first.text;
                 }
                 else
                 {
                   actors = list.fold("", (previousValue, element) => "${previousValue!} ${element.text!}, ");
                 }
               case "Duration:":
                 duration = LocalUtils.removeExtraWhiteSpaceBetweenWords(rowLineElement.text.replaceAll("Duration:", "").replaceAll("\n", "").trim());
               case "Country:":
                 List<dom.Element> list = rowLineElement.querySelectorAll("a");
                 if(list.length == 1)
                 {
                   country = list.first.text;
                 }
                 else
                 {
                   country = list.fold("", (previousValue, element) => "${previousValue!} ${element.text!}, ");
                 }
               case "Production:":
                 List<dom.Element> list = rowLineElement.querySelectorAll("a");
                 if(list.length == 1)
                 {
                   production = list.first.text;
                 }
                 else
                 {
                   production = list.fold("", (previousValue, element) => "${previousValue!} ${element.text!}, ");
                 }
             }
          }
      }
    return WatchSeriesDetail(tag2: watchSeriesCover.tag2,tag1: watchSeriesCover.tag1,title: watchSeriesCover.title,url: watchSeriesCover.url,duration: duration,genre: genre,description: description,coverUrl: watchSeriesCover.imageURL,actors: actors,country: country,production: production,ratings: ratings,releasedDate: releasedDate,id: id);

  }

  Future<Map<String,Map<String,String>>> getVideoServerLinks () async
  {
    Map<String,Map<String,String>> map = Map();
    String finalEpisodeUrl = WATCHSERIES_AJAX_EPISODE_SERVER + mediaId;
    dom.Document serverDocument = await WebUtils.getDomFromURL_Get(finalEpisodeUrl);
    List<dom.Element> serverList = serverDocument.querySelectorAll(".nav-item");

    for(dom.Element element in serverList)
      {
        Map<String,String> qualityMap = Map();
        String serverId = element.querySelector("a")!.attributes["data-linkid"]!;
        String servername = element.querySelector("span")!.text;
        if(servername == "UpCloud" || servername == "MegaCloud")
          {
            String finalServerUrl = WATCHSERIES_AJAX_SOURCE_SERVER + serverId;
            String? iframeJson = await WebUtils.makeGetRequest(finalServerUrl);
            Map<String,dynamic> jsonMap = jsonDecode(iframeJson!);
            String cloudId = jsonMap["link"].split("/").last.split("?")[0];
            String finalCloudUrl = MEGACLOUD_AJAX_SOURCE_SERVER + cloudId;
            Map<String,String> headers = {"X-Requested-With":"XMLHttpRequest"};
            String? response = await WebUtils.makeGetRequest(finalCloudUrl,headers:headers);
            String m3u8Link = jsonDecode(response!)["sources"][0]["file"];
            String? qualityLinks = await WebUtils.makeGetRequest(m3u8Link);
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
            map[servername] = qualityMap;
          }
      }

    return map;
  }
}