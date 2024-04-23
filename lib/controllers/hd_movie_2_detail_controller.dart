


import 'dart:convert';

import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_cover.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_detail.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_video_detail.dart';
import 'package:Movieverse/models/hd_movie2/hdmovie2_player_request.dart';
import 'package:Movieverse/models/hd_movie2/hdmovie2_player_response.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart';


class HdMovie2DetailController extends GetxController
{
   Map<String,String> abyssQualityCdn = {"sd":"","hd":"www","fullHd":"whw"};
   late dom.Document pageSource;

   static final HDMOVIE2_SERVER_URL = "https://hdmovie2.phd";
   static final HDMOVIE2_ADMIN_AJAX_SERVER_URL = "https://hdmovie2.phd/wp-admin/admin-ajax.php";

   Future<HdMovie2Detail> getMovieDetail (HdMovie2Cover hdMovie2Cover) async
   {
     String? director = "",released ="", runtime ="",tags="",country="",actors="N/A",description="N/A",ratings="",postId;
     pageSource = await WebUtils.getDomFromURL_Get(hdMovie2Cover.url!);

     List<HdMovie2PlayerRequest> playerList = [];
     List<dom.Element> playerElements = pageSource.querySelectorAll("#playeroptionsul .dooplay_player_option");

     for(dom.Element playerElement in playerElements)
       {
          playerList.add(HdMovie2PlayerRequest(action: "doo_player_ajax",nume: playerElement.attributes["data-nume"],post: playerElement.attributes["data-post"],type: playerElement.attributes["data-type"]));
       }

     try {
       released = pageSource.querySelector(".extra .date")!.text;
       country = pageSource.querySelector(".extra .country")!.text;
       runtime = pageSource.querySelector(".extra .runtime")!.text;
       ratings = pageSource.querySelector(".extra span[itemprop=\"contentRating\"]")!.text;
     } catch (e) {
       print(e);
     }

     List<dom.Element> tagsElementList = pageSource.querySelectorAll(".sgeneros a");
     tags = tagsElementList.fold("", (previousValue, element) => previousValue + element.text + ", ");
     description = pageSource.querySelector(".description .box_links") == null ? "N/A" : pageSource.querySelector(".description .box_links")!.text;
     postId = pageSource.querySelector("#report-video-button-field input[name=\"postid\"]")!.attributes["value"];
     try {
       List<dom.Element> castElementList = pageSource.querySelectorAll("#cast .persons")!;

       director = castElementList[0].querySelector(".data .name")!.text;
       
       actors = castElementList[1].querySelectorAll(".data .name").fold("", (previousValue, element) => previousValue + element.text! + ", ");
     } catch (e) {
       print(e);
     }

     return HdMovie2Detail(title: hdMovie2Cover.title,url: hdMovie2Cover.url,postId: postId,tags: tags,director: director,description: description,coverUrl: hdMovie2Cover.imageURL,tag1: hdMovie2Cover.tag1,tag2: hdMovie2Cover.tag2,country: country,actors: actors,ratings: ratings,releasedDate: released,duration: runtime,players: playerList);
   }

   Future<(String,Map<String,Map<String,String>>)> getVideoLinks(String movieUrl,List<HdMovie2PlayerRequest> playerList,) async
   {
     Map<String,Map<String,String>> map = Map();
     String? orignalUrl = "";
      for (HdMovie2PlayerRequest hdMovie2PlayerRequest in playerList)
        {
           String response = await WebUtils.makePostRequest(HDMOVIE2_ADMIN_AJAX_SERVER_URL, hdMovie2PlayerRequest.toJson(),headers: {"Referer":movieUrl});
           HdMovie2PlayerResponse hdMovie2PlayerResponse = HdMovie2PlayerResponse.fromJson(jsonDecode(response));

           if (hdMovie2PlayerResponse.embed_url!.contains("short.ink")) {
             orignalUrl = await WebUtils.getOriginalUrl(hdMovie2PlayerResponse.embed_url!.trim());
           if (orignalUrl!.contains("abysscdn.com")) {

             dom.Document playerDocument = await WebUtils.getDomFromURL_Get(orignalUrl!);
             List<dom.Element> scriptList = playerDocument.querySelectorAll("script");
             String? javascript = scriptList.where((element) => element.text.contains("new PLAYER(atob(")).first.text;
             String encodedBase64 = LocalUtils.getStringBetweenTwoStrings("new PLAYER(atob(\"", "\"));", javascript);
             String decodedBase64 = String.fromCharCodes(base64Decode(encodedBase64));
             HDMovie2VideoDetail hdMovie2VideoDetail = HDMovie2VideoDetail.fromJson(jsonDecode(decodedBase64));

             Map<String,String> map2 = Map();
             for(String qualitySource in hdMovie2VideoDetail.sources!)
               {
                 String? q_prefix = abyssQualityCdn[qualitySource];
                 String fullM3U8Url = "https://${hdMovie2VideoDetail.domain}/${q_prefix}${hdMovie2VideoDetail.id}";
                 map2[qualitySource.toUpperCase()] = fullM3U8Url;

               }

             map[VideoHosterEnum.Abysscdn.name] = map2;

           }
          }
           else
             {
               for(VideoHosterEnum videoHosterEnum in VideoHosterEnum.values)
               {
                 _addVideoHosterLinks(hdMovie2PlayerResponse.embed_url!.trim(), videoHosterEnum.name, map,hdMovie2PlayerResponse.embed_url!.trim());
               }
             }


        }

      return (orignalUrl!,map);
   }

   void _addVideoHosterLinks(String iframeUrl,String hostProvider,Map<String,Map<String,String>> map,String pageServerUrl)
   {
     if(iframeUrl.toLowerCase()!.contains(hostProvider.toLowerCase()))
     {
       if(map[hostProvider] == null)
       {
         Map<String,String> map2 = Map();
         map2[""] = pageServerUrl;
         map[hostProvider] = map2;
       }
     }
   }
}