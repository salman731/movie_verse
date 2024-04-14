
import 'dart:convert';

import 'package:Movieverse/controllers/main_screen_controller.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_detail.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_episode.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_season.dart';
import 'package:Movieverse/models/all_movie_land/movie_file_info.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_server_links.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;


class AllMovieLandDetailController extends GetxController
{
  late dom.Document pageDocument;

  static String ALLMOVIELAND_PLAYER_SERVER = "https://jezt294anecte.com/play/";
  static String ALLMOVIELAND_MAIN_PLAYER_SERVER = "https://jezt294anecte.com";
  static String ALLMOVIELAND_PLAYLIST_PLAYER_SERVER = "https://jezt294anecte.com/playlist/";
  bool isSeries = false;
  List<MovieFileInfo>? selectedMovieFileInfo;
  List<AllMovieLandSeason>? allMovieLandSeasonList;
  RxString selectedSeason = "1".obs;
  RxString selectedEpisode = "1".obs;
  String tokenKey = "";

  Future<AllMovieLandDetail> getMovieDetail(AllMovieLandCover allMovieLandCover) async
  {
    Map<String,List<String>> map = Map();
    pageDocument = await WebUtils.getDomFromURL_Get(allMovieLandCover.url!);
    List<dom.Element> list = pageDocument.querySelectorAll(".xfs__block")[0].querySelectorAll(".xfs__item_op");
    String? orignalName = "N/A",tags = "N/A",director = "N/A",country = "N/A",actors = "N/A",runtime = "N/A",description = "N/A", orginalLanguage = "N/A",translationLanguage ="N/A";

    for(dom.Element element in list)
      {
        String? title = element.querySelector("span")!.text;
        String? value = element.querySelector("b")!.text;

        switch(title)
        {
          case "country:":
            country = value;
          case "original name:":
            orignalName = value;
          case "runtime:":
            runtime = value;
          case "original language:":
            orginalLanguage = value;
          case "translation:":
            translationLanguage = value;
          case "director:":
            director = value;

        }
      }

    try {
      actors = pageDocument.querySelectorAll(".xfs__block")[1].querySelector(".xfs__item_actors b")!.text;
    } catch (e) {
      print(e);
    }

    List<dom.Element> list2 = pageDocument.querySelectorAll(".xfs__block .xfs__item .xfs__item--value a")!;
    tags = list2.map((e) => e.text).join(",");
    description = pageDocument.querySelector(".fs__descr--text p")!.text;
    if(tags.contains("Series"))
      {
        isSeries = true;
        String response = await getFileInfoJson();
        response = response.replaceAll(",[]", "");
        allMovieLandSeasonList = (jsonDecode(response) as List).map((e) => AllMovieLandSeason.fromJson(e)).toList();
        for(AllMovieLandSeason allMovieLandSeason in allMovieLandSeasonList!)
          {
             List<String> allMovieLandMovieEpisodeList = [];
             for (AllMovieLandEpisode allMovieLandEpisode in allMovieLandSeason.folder!)
               {
                   allMovieLandMovieEpisodeList.add(allMovieLandEpisode.episode!);
               }
             map[allMovieLandSeason.id!] = allMovieLandMovieEpisodeList;
          }

        selectedSeason.value = map.keys.first;
        selectedEpisode.value = map[selectedSeason.value]!.first;
        findSelectedSeasonEpisode();

      }
    else
      {
        String response = await getFileInfoJson();
        selectedMovieFileInfo = (jsonDecode(response) as List).map((e) => MovieFileInfo.fromJson(e)).toList();
        isSeries = false;
      }
    return AllMovieLandDetail(url: allMovieLandCover.url,title: allMovieLandCover.title,runtime: runtime,director: director,description: description,coverUrl: allMovieLandCover.imageURL,country: country,actors: actors,orginalName: orignalName,oringalLanguage: orginalLanguage,tags: tags,translationLanguage: translationLanguage,seasonEpisodeMap: map);
  }

 /* Future<List<AllMovieLandServerLinks>> getMediaServerLinks() async
  {
    Map<String,List<String>> serverMap = Map();
    List<AllMovieLandServerLinks> allMovieLandServerLinks = [];
    String mainUrl = Get.find<SearchScreenController>().ALLMOVIELAND_HOST_SERVER_URL;
    List<dom.Element> list = pageDocument.querySelectorAll("script");
    String? config = list.where((element) => element.text.contains("IndStreamPlayerConfigs")).first.text;
    String? srcID = LocalUtils.getStringBetweenTwoStrings("src: ", ",", config).replaceAll("'", "");
    dom.Document playerDocument = await WebUtils.getDomFromURL_Get(ALLMOVIELAND_PLAYER_SERVER + srcID,headers: {"Referer":mainUrl});
    List<dom.Element> list2 = playerDocument.querySelectorAll("script");
    String jsonTxt = list2.where((element) => element.text.contains("let pc")).first.text;
    String json = "{ ${LocalUtils.getStringBetweenTwoStrings("let pc = {", "};", jsonTxt)} }";
    Map<String,dynamic> decodedJson = jsonDecode(json);
    String response = await WebUtils.makePostRequest(ALLMOVIELAND_MAIN_PLAYER_SERVER + decodedJson["file"], "{}",headers: {"X-CSRF-TOKEN":decodedJson["key"],"Referer":ALLMOVIELAND_MAIN_PLAYER_SERVER});

    List<MovieFileInfo> languagesPlaylist = (jsonDecode(response) as List).map((e) => MovieFileInfo.fromJson(e)).toList();
    for(MovieFileInfo movieFileInfo in languagesPlaylist)
      {
        String? response = await WebUtils.makeGetRequest(ALLMOVIELAND_PLAYLIST_PLAYER_SERVER + movieFileInfo.file! +".txt",headers: {"X-CSRF-TOKEN":decodedJson["key"],"Referer":ALLMOVIELAND_MAIN_PLAYER_SERVER});
        String? response2 = await WebUtils.makeGetRequest(response!);
        List<String> qualityM3U8 = response2!.split("\n").where((element) => element.contains("index.m3u8")).toList();
        String finalm3u8Link = "",quality = "";
        Map<String, String> linksMap = Map();
        for(String str in qualityM3U8)
          {
            finalm3u8Link = response.replaceAll("index.m3u8", str.replaceAll("./", "") );
            quality = LocalUtils.getStringBetweenTwoStrings("./", "/index.m3u8", str);
            linksMap[quality] = finalm3u8Link;
          }
        allMovieLandServerLinks.add(AllMovieLandServerLinks(title: movieFileInfo.title,qualityM3u8LinksMap: linksMap));
      }
    return allMovieLandServerLinks;
  }*/


  Future<String> getFileInfoJson() async
  {
    Map<String,List<String>> serverMap = Map();
    List<AllMovieLandServerLinks> allMovieLandServerLinks = [];
    String mainUrl = Get.find<SearchScreenController>().ALLMOVIELAND_HOST_SERVER_URL;
    List<dom.Element> list = pageDocument.querySelectorAll("script");
    String? config = list.where((element) => element.text.contains("IndStreamPlayerConfigs")).first.text;
    String? srcID = LocalUtils.getStringBetweenTwoStrings("src: ", ",", config).replaceAll("'", "");
    dom.Document playerDocument = await WebUtils.getDomFromURL_Get(ALLMOVIELAND_PLAYER_SERVER + srcID,headers: {"Referer":mainUrl});
    List<dom.Element> list2 = playerDocument.querySelectorAll("script");
    String jsonTxt = list2.where((element) => element.text.contains("\"file\":")).first.text;
    String json = "";
    if(jsonTxt.contains("new HDVBPlayer({\""))
      {
        json = "{ ${LocalUtils.getStringBetweenTwoStrings("new HDVBPlayer({", "});", jsonTxt)} }";
      }
    else
      {
        json = "{ ${LocalUtils.getStringBetweenTwoStrings("let pc = {", "};", jsonTxt)} }";
      }
    Map<String,dynamic> decodedJson = jsonDecode(json);
    tokenKey = decodedJson["key"];
    String response = await WebUtils.makePostRequest(ALLMOVIELAND_MAIN_PLAYER_SERVER + decodedJson["file"], "{}",headers: {"X-CSRF-TOKEN":decodedJson["key"],"Referer":ALLMOVIELAND_MAIN_PLAYER_SERVER});
    return response;
  }

  Future<List<AllMovieLandServerLinks>> getServerLinks() async
  {
    List<AllMovieLandServerLinks> allMovieLandServerLinks = [];

    for(MovieFileInfo movieFileInfo in selectedMovieFileInfo!)
    {
        String? response = await WebUtils.makeGetRequest(ALLMOVIELAND_PLAYLIST_PLAYER_SERVER + movieFileInfo.file! +".txt",headers: {"X-CSRF-TOKEN":tokenKey,"Referer":ALLMOVIELAND_MAIN_PLAYER_SERVER});
        String? response2 = await WebUtils.makeGetRequest(response!);
        List<String> qualityM3U8 = response2!.split("\n").where((element) => element.contains("index.m3u8")).toList();
        String finalm3u8Link = "",quality = "";
        Map<String, String> linksMap = Map();
        for(String str in qualityM3U8)
        {
          finalm3u8Link = response.replaceAll("index.m3u8", str.replaceAll("./", "") );
          quality = LocalUtils.getStringBetweenTwoStrings("./", "/index.m3u8", str);
          linksMap[quality] = finalm3u8Link;
        }
        allMovieLandServerLinks.add(AllMovieLandServerLinks(title: movieFileInfo.title,qualityM3u8LinksMap: linksMap));
     }
    return allMovieLandServerLinks;
  }

  void findSelectedSeasonEpisode ()
  {
   selectedMovieFileInfo = allMovieLandSeasonList!.where((element) => element.id == selectedSeason.value).first.folder!.where((element) => element.episode == selectedEpisode.value).first.folder;
   print(selectedMovieFileInfo);
    /*for(AllMovieLandSeason allMovieLandSeason in allMovieLandSeasonList!)
    {
      if(season == allMovieLandSeason.id)
        {
          for (AllMovieLandEpisode allMovieLandEpisode in allMovieLandSeason.folder!)
          {
             if()
          }
        }
    }*/
  }
}