


import 'dart:convert';

import 'package:Movieverse/enums/source_enum.dart';
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
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';

enum OkRuQualityEnum
{
  mobile,
  lowest,
  low,
  sd,
  hd
}

class OkRuLink
{
  String? name;

  String? url;

  OkRuLink({this.name, this.url});
}

class HdMovie2DetailController extends GetxController
{
   Map<String,String> abyssQualityCdn = {"sd":"","hd":"www","fullHd":"whw"};
   late dom.Document pageSource;

   static final HDMOVIE2_SERVER_URL = "https://hdmovie2.app";
   static final HDMOVIE2_ADMIN_AJAX_SERVER_URL = "https://hdmovie2.app/wp-admin/admin-ajax.php";
   static final AKAMAICDN_SERVER_URL = "https://akamaicdn.life/";
   static final TWDOWN_SEARCH_SERVER_URL = "https://twdown.online/search?url=";
   static final TWDOWN_DOWNLOAD_SERVER_URL = "https://downloader.twdown.online/load_url?";

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
     postId = pageSource.querySelector("#dooplay-ajax-counter")!.attributes["data-postid"];
     try {
       List<dom.Element> castElementList = pageSource.querySelectorAll("#cast .persons")!;

       director = castElementList[0].querySelector(".data .name")!.text;
       
       actors = castElementList[1].querySelectorAll(".data .name").fold("", (previousValue, element) => previousValue + element.text! + ", ");
     } catch (e) {
       print(e);
     }

     return HdMovie2Detail(title: hdMovie2Cover.title,url: hdMovie2Cover.url,postId: postId,tags: tags,director: director,description: description,coverUrl: hdMovie2Cover.imageURL,tag1: hdMovie2Cover.tag1,tag2: hdMovie2Cover.tag2,country: country,actors: actors,ratings: ratings,releasedDate: released,duration: runtime,players: playerList);
   }

   Future<Map<String,Map<String,String>>> getVideoLinks(String movieUrl,List<HdMovie2PlayerRequest> playerList,) async
   {
     Map<String,Map<String,String>> map = Map();
     String? orignalUrl = "";
     Map<String,String> bestXheaders = Map();
      for (HdMovie2PlayerRequest hdMovie2PlayerRequest in playerList)
        {
           String response = await WebUtils.makePostRequest(HDMOVIE2_ADMIN_AJAX_SERVER_URL, hdMovie2PlayerRequest.toJson(),headers: {"Referer":movieUrl});
           HdMovie2PlayerResponse hdMovie2PlayerResponse = HdMovie2PlayerResponse.fromJson(jsonDecode(response));


           if (hdMovie2PlayerResponse.embed_url!.contains("iframe")) {
             dom.Document iframeDocument = WebUtils.getDomfromHtml(hdMovie2PlayerResponse.embed_url!);
             String? hostVideUrl = iframeDocument.querySelector("iframe")!.attributes["src"];
             if(hostVideUrl![0] == "/" && hostVideUrl![1] == "/")
               {
                 hostVideUrl = hostVideUrl.replaceAll("//", "https://");
               }
             if (hostVideUrl!.contains("short.ink")) {
                          orignalUrl = await WebUtils.getOriginalUrl(hostVideUrl!.trim());
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

                          map[VideoHosterEnum.Abysscdn.name + "_headers"] = {"Referer":orignalUrl};
                          map[VideoHosterEnum.Abysscdn.name] = map2;

                        }
                       }
                      else if (hostVideUrl.contains("akamaicdn"))
                        {
                          dom.Document pageDocument = await WebUtils.getDomFromURL_Get(hostVideUrl,headers: {"Referer":HDMOVIE2_SERVER_URL});
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

                        }
                      else if(hostVideUrl!.contains("ok.ru"))
                        {
                          String cookie = "XSRF-TOKEN=eyJpdiI6Im1oNEcyOEpndGhyTW9JNHA5ZGhLTkE9PSIsInZhbHVlIjoiQkRYd2loWVh1c3YzN280VkwwTDdPbnpJVWlWaWJNOVplK0MydmNCM0hmXC9RQlRvNVlaazk2c1ZNc25lV2FMRlgiLCJtYWMiOiI1OWIzYjdjOWI2MGZhYzQ4NGYwZTg4Y2RlYjFlYWI4MzFiNmI4NGMzNTMwMTc3MTk0ZDU3Mjk2YTA2NzNhYTlkIn0%3D; s_id=QVH0JEya2VJApNM1ASB0lJiOScfhGI7LYPMZYvwz";
                          String finalURl = TWDOWN_SEARCH_SERVER_URL + hostVideUrl;
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
                        }
             
                        // Not yet needed
                        /*else if (hdMovie2PlayerResponse.embed_url!.toLowerCase().contains("bestx") || hdMovie2PlayerResponse.embed_url!.toLowerCase().contains("watchx") || hdMovie2PlayerResponse.embed_url!.toLowerCase().contains("moviesapi"))
                          {
                            dom.Document playerDocument = await WebUtils.getDomFromURL_Get(hdMovie2PlayerResponse.embed_url!.trim(),headers: {"Referer":hdMovie2PlayerResponse.embed_url!.trim()});
                            String javaScript = playerDocument.querySelectorAll("script").where((element) => element.text.contains("JScripts")).first.text;
                            String json = LocalUtils.getStringBetweenTwoStrings("JScripts = '", "';", javaScript);
                            String mainM3u8Url = await LocalUtils.getDecrptedTextHdMovie2(json);

                            if (mainM3u8Url != "error") {
                              Map<String,String> headers = {
                                               "Accept" : "", add here removed because it blocks comment
                                               "Connection" : "keep-alive",
                                               "Sec-Fetch-Dest" : "empty",
                                               "Sec-Fetch-Mode" : "cors",
                                               "Sec-Fetch-Site" : "cross-site",
                                               "Origin" : Uri.parse(hdMovie2PlayerResponse.embed_url!.trim()).origin,
                                             };
                              String? qualityLinksString = await WebUtils.makeGetRequest(mainM3u8Url,headers: headers);
                              List<String> qualityLinks = qualityLinksString!.split("\n").where((element) => element.contains("m3u8")).toList();
                              Map<String,String> qualityMap = Map();
                              for (String qualityLink in qualityLinks)
                                {
                                  String quality = LocalUtils.getStringBeforString(".m3u8", qualityLink);
                                  qualityMap[quality] = mainM3u8Url.split("?")[0].replaceAll("video.m3u8", qualityLink);
                                }
                              if(hdMovie2PlayerResponse.embed_url!.toLowerCase().contains("bestx"))
                                {
                                  map[VideoHosterEnum.BestX.name+"_headers"] = headers;
                                  map[VideoHosterEnum.BestX.name] = qualityMap;
                                }
                              else if (hdMovie2PlayerResponse.embed_url!.toLowerCase().contains("watchx"))
                                {
                                  map[VideoHosterEnum.WatchX.name +"_headers"] = headers;
                                  map[VideoHosterEnum.WatchX.name] = qualityMap;
                                }
                              else if (hdMovie2PlayerResponse.embed_url!.toLowerCase().contains("moviesapi"))
                                {
                                  map[VideoHosterEnum.MoviesApi.name+"_headers"] = headers;
                                  map[VideoHosterEnum.MoviesApi.name] = qualityMap;
                                }
                            }
                          }*/
                        else
                        {
                          for(VideoHosterEnum videoHosterEnum in VideoHosterEnum.values)
                          {
                            _addVideoHosterLinks(hostVideUrl!.trim(), videoHosterEnum.name, map,hostVideUrl!.trim());
                          }
                        }
           }


        }

      return map;
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