

import 'dart:convert';

import 'package:Movieverse/controllers/primewire_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_detail.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_search_request.dart';
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/models/up_movies/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies/up_movies_cover.dart';
import 'package:Movieverse/utils/source_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:open_file/open_file.dart';
import 'package:Movieverse/main.dart';
import 'package:webview_flutter/webview_flutter.dart';


class SearchScreenController extends GetxController
{
   final String UPMOVIES_SERVER_URL = "https://www.upmovies.net";
   final String PRIMEWIRE_SERVER_URL = "https://www.primewire.tf";
   final String PRIMEWIRE_HOST_SERVER_URL = "https://www.primewire.tf/links/go/";
   final String ALLMOVIELAND_SEARCH_SERVER_URL = "https://allmovieland.fun/index.php?do=search";
   final String ALLMOVIELAND_HOST_SERVER_URL = "https://allmovieland.fun";
   final String PRMOVIES_SERVER_URL = "https://prmovies.rent";
   List<UpMoviesCover> upMoviesSearchList  = [];
   List<PrimeWireCover> primeWireSearchList  = [];
   List<Film1kCover> film1kSearchList  = [];
   List<AllMovieLandCover> allMovieLandSearchList  = [];
   List<PrMoviesCover> prMoviesSearchList  = [];
   RxBool isUpMoviesSourceLoading = false.obs;
   RxBool isPrimeWireSourceLoading = false.obs;
   RxBool isFilm1kSourceLoading = false.obs;
   RxBool isAllMovieLandSourceLoading = false.obs;
   RxBool isPrMoviesSourceLoading = false.obs;
   RxBool isUpMovieMoreUpMoviesLoading = false.obs;
   RxBool isPrimeWireMoreUpMoviesLoading = false.obs;
   RxBool isFilm1kMoreUpMoviesLoading = false.obs;
   RxBool isAllMovieLandMoviesLoading = false.obs;
   RxBool isPrMoviesMoviesLoading = false.obs;
   RxBool isSearchStarted = false.obs;
   String? primeWireSearchHash;
   ScrollController upMoviesScrollController = ScrollController();
   ScrollController primeWireScrollController = ScrollController();
   ScrollController film1kScrollController = ScrollController();
   ScrollController allMovieLandScrollController = ScrollController();
   ScrollController prMoviesScrollController = ScrollController();
   int upMoviesCurrentPage = 1;
   int primeWireCurrentPage = 1;
   int film1kCurrentPage = 1;
   int allMovieLandCurrentPage = 1;
   int prMoviesCurrentPage = 1;
   WebViewController? webViewController;
   String? primewireMovieTitle;
   bool isFilm1kMorePagesExist = false;
   RxBool isUpMoviesReachedMax = false.obs;
   TextEditingController homeSearchBarEditingController = TextEditingController();

  startShowingLoadingSources()
  {
    isUpMoviesSourceLoading.value = true;
    isPrimeWireSourceLoading.value = true;
    isFilm1kSourceLoading.value = true;
    isAllMovieLandSourceLoading.value = true;
    isPrMoviesSourceLoading.value = true;
  }

  Future<List<UpMoviesCover>> searchMovieInUpMovies(String pageUrl,{bool loadMore = false}) async
   {
     dom.Document document = await WebUtils.getDomFromURL_Get(pageUrl);
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
         List<UpMoviesCover> list  = await searchMovieInUpMovies(searchUpMoviesURL,loadMore: loadMore);
         upMoviesSearchList.addAll(list);
         isUpMovieMoreUpMoviesLoading.value = false;

       }
     else
       {

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
         document = await WebUtils.getDomFromURL_Get(htmlorPageUrl);
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

       primeWireCurrentPage = 1;
      // await loginIntoPrimeWire();
       //await Future.delayed(Duration(seconds: 3));
       await webViewController!.runJavaScript(""
                "document.getElementById(\"search_term\").value = \"${movieName}\";"
                "const bton = document.querySelector(\".search_container button\");"
                "bton.click();");
     } else {
       primeWireCurrentPage += 1;
       String searchUrl = LocalUtils.getPrimeWireSearchURL(movieName, primeWireCurrentPage, primeWireSearchHash!);
       List<PrimeWireCover> list = await getPrimeWireMoviesList(searchUrl,isLoadMore:isLoadMore);
       primeWireSearchList.addAll(list);
       isPrimeWireMoreUpMoviesLoading.value = false;
     }
   }

  Future<List<Film1kCover>> getFilm1MoviesList(String pageUrl) async
   {
     dom.Document document = await WebUtils.getDomFromURL_Get(pageUrl);
     List<Film1kCover> film1kList = [];
     List<dom.Element> list = document.querySelectorAll(".loop-post.vdeo.snow-b.sw03.pd08.por.ovh");
     isFilm1kMorePagesExist = document.querySelector(".nav-links") != null;
     for(dom.Element element in list)
       {
         try {
           String? imageUrl = element.querySelector(".thumb.por .por.ovh img")!.attributes["src"];
           String? title = element.querySelector(".mt08 h2")!.text;
           String? url = element.querySelector(".lka")!.attributes["href"];
           film1kList.add(Film1kCover(imageURL: imageUrl,title: title,url: url));
         } catch (e) {
           print(e);
         }
       }
     return film1kList;
   }


   Future<void> loadFilm1KMovies(String movieName,{bool isLoadMore = false}) async
   {
     if(isLoadMore && isFilm1kMorePagesExist)
       {
         isFilm1kMoreUpMoviesLoading.value = true;
         film1kCurrentPage += 1;
         String searchUrl = LocalUtils.getFilm1kSearchUrl(movieName,isLoadMore: isLoadMore,pageNo: film1kCurrentPage);
         List<Film1kCover> list = await getFilm1MoviesList(searchUrl);
         film1kSearchList.addAll(list);
         isFilm1kMoreUpMoviesLoading.value = false;
       }
     else if(!isLoadMore)
       {
         film1kCurrentPage = 1;
         String searchUrl = LocalUtils.getFilm1kSearchUrl(movieName);
         film1kSearchList = await getFilm1MoviesList(searchUrl);
         isFilm1kSourceLoading.value = false;
       }
   }

   Future<List<AllMovieLandCover>> getAllMovieLandMoviesList(String movieName,int pageNo,{String resultFrom = "1"}) async
   {
     List<AllMovieLandCover> allMovieLandCoverList = [];
     AllMovieLandSearchRequest allMovieLandSearchRequest = AllMovieLandSearchRequest(do_search: "search",full_search: "0",result_from: resultFrom,search_start:pageNo.toString(),story: movieName,subaction: "search" );
     dom.Document document = await WebUtils.getDomFromURL_Post(ALLMOVIELAND_SEARCH_SERVER_URL, allMovieLandSearchRequest.toJson());
     List<dom.Element> list = document.querySelectorAll(".short-mid.new-short");
     for(dom.Element element in list)
       {
         String? title = element.querySelector(".new-short__title.hover-op")!.text;
         String? url = element.querySelector(".new-short__title--link")!.attributes["href"];
         String? posterUrl  = ALLMOVIELAND_HOST_SERVER_URL + element.querySelector(".new-short__poster .new-short__poster--link img")!.attributes["data-src"]!;
         allMovieLandCoverList.add(AllMovieLandCover(title: title,url: url,imageURL: posterUrl));
       }
     return allMovieLandCoverList;
   }

   loadAllMovieLand(String movieName,{bool loadMore = false}) async
   {
     if(loadMore)
       {
         allMovieLandCurrentPage += 1;
         List<AllMovieLandCover> list = await getAllMovieLandMoviesList(movieName, allMovieLandCurrentPage);
         allMovieLandSearchList.addAll(list);
         isAllMovieLandMoviesLoading.value = false;
       }
     else
       {
         allMovieLandCurrentPage = 1;
         allMovieLandSearchList = await getAllMovieLandMoviesList(movieName, allMovieLandCurrentPage);
         isAllMovieLandSourceLoading.value =false;
       }
   }

   initWebViewController()
   {

     if (webViewController == null) {
       webViewController = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(const Color(0x00000000))
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {
                    if (url == "https://www.primewire.tf/" )
                      {
                        LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Logging Into Primewire.....");
                      }
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
                  else if(url.contains("https://www.primewire.tf/movie") || url.contains("https://www.primewire.tf/tv"))
                    {
                      Map<String,List<String>> map = await getServerPages();
                      LoaderDialog.stopLoaderDialog();
                      ServerListDialog.showServerListDialog(navigatorKey.currentContext!, map,primewireMovieTitle!,decodeiframe: false,videotoIframeAllowed: true);
                    }
                  else if (url == "https://www.primewire.tf/" )
                    {
                      await loginIntoPrimeWire();
                      LoaderDialog.stopLoaderDialog();

                    }
                  },
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (NavigationRequest request) {
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse('https://primewire.tf'));
     }

     //webViewController.runJavaScript(javaScript)
   }

   Future<String?> getHtmlFromPrimewire() async
   {
       Object html = await webViewController!.runJavaScriptReturningResult("window.document.getElementsByTagName('html')[0].outerHTML;");
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

   loginIntoPrimeWire() async
   {
     String email = "salmanilyas731@gmail.com";
     String password = "internet50";
     await webViewController!.runJavaScript(""
         "document.getElementById(\"session_email\").value = \"${email}\";"
         "document.getElementById(\"session_password\").value = \"${password}\";"
         "const form = document.querySelector(\".secure\");"
         "form.submit();");

   }

   Future<List<PrMoviesCover>> searchPrMoviesList (String pageUrl) async
   {
     dom.Document pageDocument = await WebUtils.getDomFromURL_Get(pageUrl);
     dom.Element element = pageDocument.querySelector(".movies-list.movies-list-full")!;
     return SourceUtils.getPrMoviesCategoriesDetailList(element);
   }


   loadPrMoviesMovies(String movieName,{bool isLoadMore = false}) async
   {
     if(isLoadMore)
       {
         prMoviesCurrentPage += 1;
         String searchedUrl = LocalUtils.getPrMoviesSearchUrl(movieName,isLoadMore: true,pageNo: prMoviesCurrentPage);
         isPrMoviesMoviesLoading.value = true;
         List<PrMoviesCover> prMoviesList = await searchPrMoviesList(searchedUrl);
         prMoviesSearchList.addAll(prMoviesList);
         isPrMoviesMoviesLoading.value = false;
       }
     else
       {
         prMoviesCurrentPage = 1;
         String searchedUrl = LocalUtils.getPrMoviesSearchUrl(movieName,isLoadMore: false);
         prMoviesSearchList = await searchPrMoviesList(searchedUrl);
         isPrMoviesSourceLoading.value = false;
       }
   }




}