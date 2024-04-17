

import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/enums/video_quality_enum.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_detail.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class PrMoviesDetailController extends GetxController
{
  late dom.Document pageSource;
  final String PRMOVIES_SERVER_URL = "https://prmovies.rent";
  final String MINOPLRES_SERVER_URL = "https://minoplres.xyz";

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
        case "Country:":
          country = element.querySelector("a")!.text;
        case "Networks:":
          networks = element.querySelector("a")!.text;
      }
    }

    //ratings = pageSource.querySelector(".mvic-info .mvici-right .imdb_r p span")!.text;
    //getServerPages();

    return PrMoviesDetail(url: prMoviesCover.url,title: prMoviesCover.title,ratings: ratings,actors: actors,country: country,coverUrl: prMoviesCover.imageURL,description: description,genre: genre,director: director,languageQuality: languageQuality,released: released,runtime: runtime,tags: prMoviesCover.tag,studio: studio,networks: networks,tvStatus: tvStatus);
  }

  Future<Map<String,String>> getServerPages() async
  {
    Map<String,String> map = Map();
    List<dom.Element> list = pageSource.querySelectorAll(".movieplay iframe");
    String? iframeSrc = list.where((element) => element.attributes["src"]!.contains("minoplres")).first.attributes["src"];
    dom.Document document = await WebUtils.getDomFromURL_Get(list[0].attributes["src"]!,headers: {"Referer":PRMOVIES_SERVER_URL});
    List<dom.Element> listJavascript = document.querySelectorAll("script[type=\"text/javascript\"]");
    String javaScriptText = listJavascript.where((element) => element.text.contains("sources: [{file:\"")).first.text;
    String m3u8Url = LocalUtils.getStringBetweenTwoStrings("sources: [{file:\"","\"}]" , javaScriptText);
    if(!m3u8Url.contains(",l,h,.urlset"))
      {
        m3u8Url = m3u8Url.replaceAll("_l", "_,l,h,.urlset");
        m3u8Url = m3u8Url.replaceAll("_h", "_,l,h,.urlset");
      }
    String? response = await WebUtils.makeGetRequest(m3u8Url,headers: {"Referer":MINOPLRES_SERVER_URL});
    List<String> m3u8UrlList = response!.split("\n");
    List<String> qualityUrlList = [];
    for(String url in m3u8UrlList)
      {

        if(url.contains("_l/") && url.contains("m3u8"))
          {
            map["Minoplres(${VideoQualityEnum.Low.name})"] = url;
          }
        else if(url.contains("_h/") && url.contains("m3u8"))
        {
          map["Minoplres(${VideoQualityEnum.High.name})"] = url;
        }
      }
    return map;
  }
}