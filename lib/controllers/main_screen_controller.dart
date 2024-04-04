

import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/screens/movie_detail_screen.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:open_file/open_file.dart';
import 'package:Movieverse/main.dart';


class MainScreenController extends GetxController
{
   final String UPMOVIES_SERVER_URL = "https://www.upmovies.net";
   List<UpMoviesCover> upMoviesSearchList  = [];
   RxBool isUpMoviesSourceLoading = false.obs;
   RxBool isMoreUpMoviesLoading = false.obs;
   RxBool isSearchStarted = false.obs;
   ScrollController upMoviesScrollController = ScrollController();
   int upMoviesCurrentPage = 1;

  Future<List<UpMoviesCover>> searchMovieInUpMovies(String pageUrl,{bool loadMore = false}) async
   {
     dom.Document document = await HtmlParsingUtils.getDomFromURL(pageUrl);
     List<UpMoviesCover> upMoviesCoverList = [];
     List<dom.Element>  listItems = document.getElementsByClassName("shortItem listItem");
     for (int i = 1; i<listItems.length;i++)
       {
         List<dom.Element> list = listItems[i].querySelectorAll(".poster.item-flip")!;
         String? movieUrl = list[0].querySelector("a")!.attributes["href"];
         String? moviePosterUrl = list[0].querySelector("img")!.attributes["src"];
         String? movieTitle = listItems[i].querySelector(".leftInfo .title a")!.text;
         List<dom.Element> list2 = listItems[i].querySelectorAll(".itemInfo .leftInfo .file-info p");
         String? year = list2[4].text.replaceAll("Year: ", "");
         upMoviesCoverList.add(UpMoviesCover(title: movieTitle,imageURL: moviePosterUrl,url: movieUrl,year: year));
       }
     return upMoviesCoverList;
   }

   loadMoviesfromUpMovies(String movieName,{bool loadMore = false}) async
   {
     if(!loadMore)
     {
       upMoviesCurrentPage = 1;
     }
     else
       {
         upMoviesCurrentPage += 1;
       }
     String searchUpMoviesURL = LocalUtils.getUpMoviesSearchURL(movieName,isLoadMore: loadMore,page: upMoviesCurrentPage);
     if(loadMore)
       {
         isMoreUpMoviesLoading.value = true;
         List<UpMoviesCover> list  = await searchMovieInUpMovies(searchUpMoviesURL,loadMore: loadMore);
         upMoviesSearchList.addAll(list);
         isMoreUpMoviesLoading.value = false;
       }
     else
       {
         isUpMoviesSourceLoading.value = true;
         upMoviesSearchList = await searchMovieInUpMovies(searchUpMoviesURL,loadMore: loadMore);
         isUpMoviesSourceLoading.value = false;
       }
   }


   getUpMovieSearchPagesInfo()
   {

   }

   /*Future<String?> playVIPServerUrlFromUpMoviesPage(String pageUrl,String title) async
   {
     dom.Document document = await HtmlParsingUtils.getDomFromURL(pageUrl);

     List<dom.Element> list = document.getElementsByClassName("player-iframe animation");
     String? encodedData = list[0].querySelector("script")!.text!;
     String encodedEmbededUrl = LocalUtils.getStringBetweenTwoStrings("document.write(Base64.decode(", "));", encodedData);
     String eplayVid = LocalUtils.decodeUpMoviesIframeEmbedUrl(encodedEmbededUrl);
     dom.Document iframeDocument = await HtmlParsingUtils.getDomFromURL(eplayVid);
     String? eplayMp4Url = iframeDocument.querySelector("source")!.attributes["src"];
     LocalUtils.openAndPlayVideoWithMxPlayer_Android(eplayMp4Url!, title, "https://eplayvid.net",MIME.applicationMp4);
     ExternalVideoPlayerLauncher.launchMxPlayer(
         eplayMp4Url!, MIME.applicationMp4, {
       "title": title,
       "headers":["referer","https://eplayvid.net"]
     });
     List<dom.Element> list = document.querySelectorAll("iframe");
     print(list);
     return url;
   }*/

  /* Future<UpMovieDetail?> getMovieDetail(UpMoviesCover upMoviesCover) async
   {
     dom.Document document = await HtmlParsingUtils.getDomFromURL(upMoviesCover.url!);
     List<dom.Element> list = document.querySelectorAll(".film-detail-right .film-detail .about .features ul li");
     String genre = LocalUtils.getStringAfterStartStringToEnd("Genres: ", list[0].text);
     String country = LocalUtils.getStringAfterStartStringToEnd("Country: ", list[1].text);
     String director = LocalUtils.getStringAfterStartStringToEnd("Director: ", list[2].text);
     String duration = LocalUtils.getStringAfterStartStringToEnd("Duration: ", list[3].text);
     String year = LocalUtils.getStringAfterStartStringToEnd("Year: ", list[4].text);
     String actors = LocalUtils.getStringAfterStartStringToEnd("Actors: ", list[5].text);
     String? description = document.querySelector(".film-detail-right .film-detail .textSpoiler")!.text;
     return UpMovieDetail(year: year,url: upMoviesCover.url,title: upMoviesCover.title,actors: actors,country: country,coverUrl: upMoviesCover.imageURL,description: description,director: director,duration: duration,genre: genre);
   }*/


}