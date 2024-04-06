

import 'dart:convert';

import 'package:Movieverse/controllers/primewire_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/models/prime_wire_cover.dart';
import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/screens/primewire_movie_detail_screen.dart';
import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/screens/up_movie_detail_screen.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:open_file/open_file.dart';
import 'package:Movieverse/main.dart';
import 'package:webview_flutter/webview_flutter.dart';


class MainScreenController extends GetxController
{
   final String UPMOVIES_SERVER_URL = "https://www.upmovies.net";
   final String PRIMEWIRE_SERVER_URL = "https://www.primewire.tf";
   final String PRIMEWIRE_HOST_SERVER_URL = "https://www.primewire.tf/links/go/";
   List<UpMoviesCover> upMoviesSearchList  = [];
   List<PrimeWireCover> primeWireSearchList  = [];
   RxBool isUpMoviesSourceLoading = false.obs;
   RxBool isPrimeWireSourceLoading = false.obs;
   RxBool isUpMovieMoreUpMoviesLoading = false.obs;
   RxBool isPrimeWireMoreUpMoviesLoading = false.obs;
   RxBool isSearchStarted = false.obs;
   String? primeWireSearchHash;
   ScrollController upMoviesScrollController = ScrollController();
   ScrollController primeWireScrollController = ScrollController();
   int upMoviesCurrentPage = 1;
   int primeWireCurrentPage = 1;
   late final WebViewController webViewController;
   String? primewireMovieTitle;

  Future<List<UpMoviesCover>> searchMovieInUpMovies(String pageUrl,{bool loadMore = false}) async
   {
     dom.Document document = await WebUtils.getDomFromURL(pageUrl);
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
         isUpMovieMoreUpMoviesLoading.value = true;
         List<UpMoviesCover> list  = await searchMovieInUpMovies(searchUpMoviesURL,loadMore: loadMore);
         upMoviesSearchList.addAll(list);
         isUpMovieMoreUpMoviesLoading.value = false;
       }
     else
       {
         isUpMoviesSourceLoading.value = true;
         upMoviesSearchList = await searchMovieInUpMovies(searchUpMoviesURL,loadMore: loadMore);
         isUpMoviesSourceLoading.value = false;
       }
   }

   Future<List<PrimeWireCover>> getPrimeWireMoviesList(String htmlorPageUrl,{bool isLoadMore = false}) async
   {
     List<PrimeWireCover> primewireList = [];
     dom.Document document;
     if(isLoadMore)
       {
         document = await WebUtils.getDomFromURL(htmlorPageUrl);
       }
     else
       {
         document = WebUtils.getDomfromHtml(htmlorPageUrl);
       }
     List<dom.Element> list = document.querySelectorAll(".index_item.index_item_ie");
     for(dom.Element element in list)
       {
         String? title = element.querySelectorAll("a")[0].attributes["title"];
         String? url = PRIMEWIRE_SERVER_URL + element.querySelectorAll("a")[0].attributes["href"]!;
         String? posterUrl = PRIMEWIRE_SERVER_URL + element.querySelectorAll("a img")[0].attributes["src"]!;
         primewireList.add(PrimeWireCover(title: title,url: url,imageURL: posterUrl));
       }
     return primewireList;
   }

   loadPrimeWireMovies(String movieName,{bool isLoadMore = false}) async
   {
     if (!isLoadMore) {
       isPrimeWireSourceLoading.value = true;
       primeWireCurrentPage = 1;
       await webViewController.runJavaScript(""
                "document.getElementById(\"search_term\").value = \"${movieName}\";"
                "const bton = document.querySelector(\".search_container button\");"
                "bton.click();");
     } else {
       primeWireCurrentPage += 1;
       String searchUrl = LocalUtils.getPrimeWireSearchURL(movieName, primeWireCurrentPage, primeWireSearchHash!);
       isPrimeWireMoreUpMoviesLoading.value = true;
       List<PrimeWireCover> list = await getPrimeWireMoviesList(searchUrl,isLoadMore:isLoadMore);
       primeWireSearchList.addAll(list);
       isPrimeWireMoreUpMoviesLoading.value = false;
     }
   }

   initWebViewController()
   {
     webViewController = WebViewController()
       ..setJavaScriptMode(JavaScriptMode.unrestricted)
       ..setBackgroundColor(const Color(0x00000000))
       ..setNavigationDelegate(
         NavigationDelegate(
           onProgress: (int progress) {
             // Update loading bar.
           },
           onPageStarted: (String url) {

           },
           onPageFinished: (String url) async {

           if(url.contains("https://www.primewire.tf/filter"))
             {
               Uri uri = Uri.parse(url);
               primeWireSearchHash = uri.queryParameters["ds"];
               String? decodedString =  await getHtmlFromPrimewire();
               primeWireSearchList = await getPrimeWireMoviesList(decodedString!);
               isPrimeWireSourceLoading.value = false;
             }
           else if(url.contains("https://www.primewire.tf/movie"))
             {
               Map<String,List<String>> map = await getServerPages();
               LoaderDialog.stopLoaderDialog();
               ServerListDialog.showServerListDialog(navigatorKey.currentContext!, map,primewireMovieTitle!,decodeiframe: false,videotoIframeAllowed: true);
             }
           },
           onWebResourceError: (WebResourceError error) {},
           onNavigationRequest: (NavigationRequest request) {
             return NavigationDecision.navigate;
           },
         ),
       )
       ..loadRequest(Uri.parse('https://primewire.tf'));

     //webViewController.runJavaScript(javaScript)
   }

   Future<String?> getHtmlFromPrimewire() async
   {
       Object html = await webViewController.runJavaScriptReturningResult("window.document.getElementsByTagName('html')[0].outerHTML;");
       String decodedHtml = json.decode(html.toString());
       return decodedHtml;

   }

   Future<Map<String,List<String>> >getServerPages() async
   {
     String? html = await getHtmlFromPrimewire();
     dom.Document document = WebUtils.getDomfromHtml(html!);
     Map <String,List<String>> map = Map();
     List<dom.Element> list = document.querySelectorAll(".actual_tab .movie_version");

     for(dom.Element element in list)
     {
       String source = element.querySelector(".version-host")!.text;
       String sourceUrl = PRIMEWIRE_HOST_SERVER_URL + element.querySelector(".go-link.propper-link.popper.ico-btn")!.attributes["key"]!;
       _addServerPage(source!,VideoHosterEnum.ePlayVid.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.Dood.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.DropLoad.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.FileLions.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.MixDrop.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.StreamTape.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.StreamVid.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.StreamWish.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.UpStream.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.VidMoly.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.Vidoza.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.Voe.name,map,sourceUrl!);
       _addServerPage(source!,VideoHosterEnum.VTube.name,map,sourceUrl!);
     }

     print(map);

     /*for(int i = 0;i<list.length;i++)
    {
      String? providerLogoImageUrl = list[i].querySelector(".server_version img")!.attributes["src"];
      String? providerPageUrl = list[i].querySelector(".server_version a")!.attributes["href"];
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.ePlayVid.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.Dood.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.DropLoad.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.FileLions.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.MixDrop.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.StreamTape.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.StreamVid.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.StreamWish.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.UpStream.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.VidMoly.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.Vidoza.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.VoeSX.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.VTubeTo.name,map,providerPageUrl!);
    }*/
     return map;
   }

   void _addServerPage(String providerName,String hostProvider,Map<String,List<String>> map,String pageServerUrl)
   {
     if(providerName.toLowerCase()!.contains(hostProvider.toLowerCase()))
     {
       if(map[hostProvider] == null)
       {
         List<String> list = [];
         list.add(pageServerUrl!);
         map[hostProvider] = list;
       }
       else
       {
         map[hostProvider]!.add(pageServerUrl!);
       }
     }
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