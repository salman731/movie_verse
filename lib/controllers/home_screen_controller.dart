

import 'package:Movieverse/constants/category_urls_contants.dart';
import 'package:Movieverse/enums/all_movie_land_home_category_enum.dart';
import 'package:Movieverse/enums/cinezone_home_category_enum.dart';
import 'package:Movieverse/enums/goku_home_category_enum.dart';
import 'package:Movieverse/enums/hd_movie_2_home_screen_category_enum.dart';
import 'package:Movieverse/enums/pr_movies_home_category_enum.dart';
import 'package:Movieverse/enums/primewire_home_screen_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/enums/watch_movies_home_category_enum.dart';
import 'package:Movieverse/enums/watch_series_home_screen_category_enum.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/cinezone/cinezone_cover.dart';
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/goku/goku_cover.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/models/up_movies/up_movies_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';
import 'package:Movieverse/models/watch_series/watch_series_cover.dart';
import 'package:Movieverse/utils/source_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class HomeScreenController extends GetxController
{
  final String UPMOVIES_SERVER_URL = "https://www.upmovies.net";
  final String PRIMEWIRE_SERVER_URL = "https://www.primewire.tf";
  final String AllMOVIELAND_SERVER_URL = "https://allmovieland.fun";
  final String PRMOVIES_SERVER_URL = "https://prmovies.rent";
  final String FILM1K_SERVER_URL = "https://www.film1k.com";
  final String WATCHMOVIES_SERVER_URL = "https://www.watch-movies.com.pk";
  final String HDMOVIE2_SERVER_URL = "https://hdmovie2.video";
  final String WATCHSERIES_HOME_SERVER_URL = "https://watchseries.pe/home";
  final String CINEZONE_HOME_SERVER_URL = "https://cinezone.to/home";
  final String CINEZONE_SERVER_URL = "https://cinezone.to";
  final String GOKU_SERVER_URL = "https://goku.sx";
  final String GOKU_HOME_SERVER_URL = "https://goku.sx/home";
  Map<String,List<UpMoviesCover>> upMoviesCategoryListMap = <String,List<UpMoviesCover>>{};
  Map<String,List<PrimeWireCover>> primewireCategoryListMap = <String,List<PrimeWireCover>>{};
  Map<String,List<AllMovieLandCover>> allMovieLandCategoryListMap = <String,List<AllMovieLandCover>>{};
  Map<String,List<PrMoviesCover>> prMoviesCategoryListMap = <String,List<PrMoviesCover>>{};
  Map<String,List<Film1kCover>> film1kCategoryListMap = <String,List<Film1kCover>>{};
  Map<String,List<WatchMoviesCover>> watchMoviesCategoryListMap = <String,List<WatchMoviesCover>>{};
  Map<String,List<HdMovie2Cover>> hdMovie2CategoryListMap = <String,List<HdMovie2Cover>>{};
  Map<String,List<WatchSeriesCover>> watchSeriesCategoryListMap = <String,List<WatchSeriesCover>>{};
  Map<String,List<CineZoneCover>> cineZoneCategoryListMap = <String,List<CineZoneCover>>{};
  Map<String,List<GokuCover>> gokuCategoryListMap = <String,List<GokuCover>>{};

  Rx<SourceEnum> selectedSource = SourceEnum.PrMovies.obs;
  RxBool isUpMoviesHomePageLoading = false.obs,
      isPrimewireHomePageLoading = false.obs,
      isAllMovieLandHomePageLoading = false.obs,
      isPrMoviesHomePageLoading = false.obs,
      isFilm1kHomePageLoading = false.obs,
      isWatchMoviesHomePageLoading = false.obs,
      isHdMovie2HomePageLoading = false.obs,
      isWatchSeriesHomePageLoading = false.obs,
      isCineZoneHomePageLoading = false.obs,
      isGokuHomePageLoading = false.obs;


  Future<void> loadUpMoviesHomeScreen() async
   {
     dom.Document sourceDocument = await WebUtils.getDomFromURL_Get(UPMOVIES_SERVER_URL);
     // Load Slider Movies (New Movies)
     List<dom.Element> list = sourceDocument.querySelectorAll(".swiper-slide.smallItem.shortItem.listItem.beforeLoad .itemBody");
     List<UpMoviesCover> newMoviesList = [];
     for (dom.Element element in list)
       {
         String? pageUrl = element.querySelectorAll(".poster.item-flip a")[0].attributes["href"];
         String? posterUrl = element.querySelectorAll(".poster.item-flip a img")[0].attributes["src"];
         String? title = element.querySelector("a .name")!.text;
         newMoviesList.add(UpMoviesCover(title: title,url: pageUrl,imageURL: posterUrl));
       }

     upMoviesCategoryListMap[UpMoviesHomeCategoryEnum.LatestMovies.name] = newMoviesList;
     // Load Top Movies
     List<dom.Element> list2 = sourceDocument.querySelectorAll(".moviesList #tabContents .tabContent.active a");
     List<UpMoviesCover> topMoviesList = [];
     for(dom.Element element in list2)
       {
         String? pageUrl = element.attributes["href"];
         String? title = element.querySelector(".leftInfo .title")!.text + " + " + element.querySelector(".leftInfo .title-gray")!.text;
         String? posterUrl = element.querySelector(".poster.item-flip img")!.attributes["src"];
         topMoviesList.add(UpMoviesCover(title: title,url: pageUrl,imageURL: posterUrl));
       }

     upMoviesCategoryListMap[UpMoviesHomeCategoryEnum.TopMovies.name] = topMoviesList;

     // Load Anime,Cartoons,Tv Series, Asian Drama

     List<dom.Element> list3 = sourceDocument.querySelectorAll(".main-section .main-section-left .listcate");
     for(dom.Element element in list3)
       {
         String? category = element.querySelector(".main-heading")!.text.trim();

         switch(category)
         {
           case "TV SERIES":
             List<UpMoviesCover> tvSeriesList = getUpMovieListByCategories(element);
             upMoviesCategoryListMap[UpMoviesHomeCategoryEnum.TvSeries.name] = tvSeriesList;
           case "ANIME":
             List<UpMoviesCover> animeList = getUpMovieListByCategories(element);
             upMoviesCategoryListMap[UpMoviesHomeCategoryEnum.Anime.name] = animeList;
           case "CARTOONS":
             List<UpMoviesCover> cartoonsList = getUpMovieListByCategories(element);
             upMoviesCategoryListMap[UpMoviesHomeCategoryEnum.Cartoons.name] = cartoonsList;
           case "ASIAN DRAMAS":
             List<UpMoviesCover> asianDramasList = getUpMovieListByCategories(element);
             upMoviesCategoryListMap[UpMoviesHomeCategoryEnum.AsianDramas.name] = asianDramasList;
         }
       }

     isUpMoviesHomePageLoading.value = true;

   }

  List<UpMoviesCover> getUpMovieListByCategories(dom.Element element)
   {
     List<UpMoviesCover> list  = [];
     List<dom.Element> elementList = element.querySelectorAll(".shortItem.listItem");
     for(dom.Element element in elementList)
       {
         String? pageUrl = element.querySelector(".poster.item-flip a")!.attributes["href"];
         String? posterUrl = element.querySelector(".poster.item-flip a img")!.attributes["src"];
         String? title = element.querySelector(".title a")!.text;
         list.add(UpMoviesCover(title: title,imageURL: posterUrl,url: pageUrl));
       }
     return list;
   }

  Future<void> loadPrimewireHomeScreen() async
   {
      for(MapEntry<String,String> mapEntry in PrimeWireCategoryUrlsContant.urlsMap.entries)
        {
          List<PrimeWireCover> coverList = [];
          dom.Document sourceDocument = await WebUtils.getDomFromURL_Get(mapEntry.value);

          List<dom.Element> list = sourceDocument.querySelectorAll(".index_item.index_item_ie");

          for(dom.Element element in list)
            {
              String? title = element.querySelectorAll("a")[0].attributes["title"];
              if(mapEntry.key == PrimewireHomeScreenCategoryEnum.Featured.name)
                {
                  String genre = "";
                  List<dom.Element> genreList = element.querySelectorAll(".item_categories a");
                  title = title! + "+" + genreList.fold<String>("", (previousValue, element) => previousValue + element.text + " ");
                }
              String? url = PRIMEWIRE_SERVER_URL + element.querySelectorAll("a")[0].attributes["href"]!;
              String? posterUrl = PRIMEWIRE_SERVER_URL + element.querySelectorAll("a img")[0].attributes["src"]!;
              coverList.add(PrimeWireCover(title: title,url: url,imageURL: posterUrl));
            }
          PrimewireHomeScreenCategoryEnum primewireHomeScreenCategoryEnum = PrimewireHomeScreenCategoryEnum.values.firstWhere((e) => e.toString() == 'PrimewireHomeScreenCategoryEnum.' + mapEntry.key);
          switch(primewireHomeScreenCategoryEnum)
          {
            case PrimewireHomeScreenCategoryEnum.Featured:
              primewireCategoryListMap[PrimewireHomeScreenCategoryEnum.Featured.name] = coverList;
            case PrimewireHomeScreenCategoryEnum.Streaming:
              primewireCategoryListMap[PrimewireHomeScreenCategoryEnum.Streaming.name] = coverList;
            case PrimewireHomeScreenCategoryEnum.InTheaters:
              primewireCategoryListMap[PrimewireHomeScreenCategoryEnum.InTheaters.name] = coverList;
            case PrimewireHomeScreenCategoryEnum.Latest:
              primewireCategoryListMap[PrimewireHomeScreenCategoryEnum.Latest.name] = coverList;
            case PrimewireHomeScreenCategoryEnum.Trending:
              primewireCategoryListMap[PrimewireHomeScreenCategoryEnum.Trending.name] = coverList;
            case PrimewireHomeScreenCategoryEnum.Recent:
              primewireCategoryListMap[PrimewireHomeScreenCategoryEnum.Recent.name] = coverList;
          }
        }
      isPrimewireHomePageLoading.value = true;
   }

  Future<void> loadAllMovieLandHomeScreen() async
  {
    dom.Document sourceDocument = await WebUtils.getDomFromURL_Get(AllMOVIELAND_SERVER_URL);
    List<dom.Element> list = sourceDocument.querySelectorAll(".owl-carousel.main__block--carousel-big .short-big.new-short");
    List<AllMovieLandCover> featuredList = [];

    for(dom.Element element in list)
      {
        String? title = element.querySelector(".new-short__poster a h3")!.text;
        String? url = element.querySelectorAll(".new-short__poster a")[1].attributes["href"];
        String? posterUrl = element.querySelectorAll(".new-short__poster a img")[0].attributes["data-src"];
        featuredList.add(AllMovieLandCover(title: title,url: url,imageURL: posterUrl));
      }

    allMovieLandCategoryListMap[AllMovieLandHomeCategoryEnum.Featured.name] = featuredList;

    List<dom.Element> list2 = sourceDocument.querySelectorAll(".main__block");
    for(int i = 1;i<list2.length;i++)
      {
        String? title = list2[i].querySelector(".main__block-title .main__block-title--text")!.text;

        switch(title)
        {
          case "Bollywood":
            allMovieLandCategoryListMap[AllMovieLandHomeCategoryEnum.Bollywood.name] = getAllMovieLandCategorisList(list2[i]);
          case "Hollywood":
            allMovieLandCategoryListMap[AllMovieLandHomeCategoryEnum.Hollywood.name] = getAllMovieLandCategorisList(list2[i]);
          case "TV Series":
            allMovieLandCategoryListMap[AllMovieLandHomeCategoryEnum.TvSeries.name] = getAllMovieLandCategorisList(list2[i]);
          case "Cartoons":
            allMovieLandCategoryListMap[AllMovieLandHomeCategoryEnum.Cartoons.name] = getAllMovieLandCategorisList(list2[i]);
        }
      }
    isAllMovieLandHomePageLoading.value = true;

  }

  List<AllMovieLandCover> getAllMovieLandCategorisList(dom.Element element)
  {
    List<AllMovieLandCover> coverList = [];
    List<dom.Element> list = element.querySelectorAll(".short-mid.new-short");

    for(int i = 0;i<list.length - 1;i++)
      {
        String? title = list[i].querySelector(".new-short__title.hover-op")!.text;
        String? url = list[i].querySelector(".new-short__poster--link")!.attributes["href"];
        String? posterUrl = AllMOVIELAND_SERVER_URL + list[i].querySelector(".new-short__poster--link img")!.attributes["data-src"]!;
        coverList.add(AllMovieLandCover(title:title,imageURL: posterUrl,url: url));
      }
    return coverList;
  }

  updateSource()
  {
    update(["updateHomeScreen"]);
  }

  Future<void> loadPrMoviesHomeScreen() async
  {
    dom.Document sourceDocument = await WebUtils.getDomFromURL_Get(PRMOVIES_SERVER_URL);
    dom.Element featuredElement = sourceDocument.querySelector("#movie-featured")!;
    dom.Element topIMDBElement = sourceDocument.querySelector("#top-imdb")!;
    prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Featured.name] = SourceUtils.getPrMoviesCategoriesDetailList(featuredElement);
    prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.TopIMDB.name] = SourceUtils.getPrMoviesCategoriesDetailList(topIMDBElement);

    List<dom.Element> categoryElementList = sourceDocument.querySelectorAll(".movies-list-wrap.mlw-latestmovie");

    for(dom.Element element in categoryElementList)
      {
        String? categoryTitle = element.querySelector(".ml-title .pull-left")!.text.trim();

        switch(categoryTitle)
         {
          case "Cinema Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Cinema.name] = SourceUtils.getPrMoviesCategoriesDetailList(element);
          case "Bollywood Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Bollywood.name] = SourceUtils.getPrMoviesCategoriesDetailList(element);
          case "Dual Audio Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.DualAudioMovies.name] = SourceUtils.getPrMoviesCategoriesDetailList(element);
          case "Hot Series":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.HotSeries.name] = SourceUtils.getPrMoviesCategoriesDetailList(element);
          case "Hollywood Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Hollywood.name] = SourceUtils.getPrMoviesCategoriesDetailList(element);
          case "English Series":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.EnglishSeries.name] = SourceUtils.getPrMoviesCategoriesDetailList(element);
        }
      }

    isPrMoviesHomePageLoading.value = true;
  }

  Future<void> loadFilm1kHomeScreen() async
  {
    dom.Document pageDocument = await WebUtils.getDomFromURL_Get(FILM1K_SERVER_URL);
    film1kCategoryListMap["Featured"] = SourceUtils.getFilm1kMoviesList(pageDocument);
    List<dom.Element> list = pageDocument.querySelectorAll(".ctgr.snow-b.sw03.pd08.por.ovh.brp.dfx.aic .lka");

    for(dom.Element element in list)
      {
        String? genreUrl = element.attributes["href"];
        String? genre = element.querySelector("span")!.text;
        dom.Document genreDocument = await WebUtils.getDomFromURL_Get(genreUrl!);
        film1kCategoryListMap[genre] = SourceUtils.getFilm1kMoviesList(genreDocument);
      }

    isFilm1kHomePageLoading.value = true;



  }

  Future<void> loadWatchMoviesHomeScreen() async
  {
    dom.Document pageDocument = await WebUtils.getDomFromURL_Get(WATCHMOVIES_SERVER_URL);
    dom.Element moviesElement = pageDocument.querySelector("#hpost")!;

    List<WatchMoviesCover> watchMoviesCoverList = SourceUtils.getWatchMoviesList(moviesElement);

    watchMoviesCategoryListMap[WatchMoviesHomeScreenCategoryEnum.Featured.name] = watchMoviesCoverList.sublist(0,12);
    watchMoviesCategoryListMap[WatchMoviesHomeScreenCategoryEnum.Latest.name] = watchMoviesCoverList.sublist(12,watchMoviesCoverList.length);

    for (MapEntry<String,String> mapEntry in WatchMoviesCategoryUrlsContant.urlsMap.entries)
      {
        List<WatchMoviesCover> coverList = [];
        dom.Document categoryPageSource = await WebUtils.getDomFromURL_Get(mapEntry.value);
        dom.Element moviesElement = categoryPageSource.querySelector(".postcont")!;
        watchMoviesCategoryListMap[mapEntry.key] = SourceUtils.getWatchMoviesList(moviesElement);
      }

    isWatchMoviesHomePageLoading.value =true;

  }


  Future<void> loadHdMovie2HomeScreen () async
  {
    dom.Document pageDocument = await WebUtils.getDomFromURL_Get(HDMOVIE2_SERVER_URL);
    dom.Element featuredElement = pageDocument.querySelector(".items.featured")!;
    hdMovie2CategoryListMap[HdMovie2HomeScreenCategoryEnum.Featured_Movies.name] = getHdMovie2List(featuredElement);
    dom.Element latestElement = pageDocument.querySelector(".items.normal")!;
    hdMovie2CategoryListMap[HdMovie2HomeScreenCategoryEnum.Latest_Movies.name] = getHdMovie2List(latestElement);

    List<HdMovie2Cover> coverList = [];
    List<dom.Element> popularElementList = pageDocument.querySelectorAll(".widget.doothemes_widget .w_item_b")!;
    for(dom.Element popularElement in popularElementList)
      {
        String? title = popularElement.querySelector(".data h3")!.text;
        String? url = popularElement.querySelector("a")!.attributes["href"];
        String? tag1 = popularElement.querySelector(".data .wextra span")!.text;
        String? posterUrl = popularElement.querySelector(".image img")!.attributes["data-wpfc-original-src"];
        String? tag2 = popularElement.querySelector(".data .wextra b")!.text;
        coverList.add(HdMovie2Cover(title: title,url: url,imageURL: posterUrl,tag1: tag1,tag2: tag2));
      }

    hdMovie2CategoryListMap[HdMovie2HomeScreenCategoryEnum.Popular_Movies.name] = coverList;

    isHdMovie2HomePageLoading.value = true;
  }

  List<HdMovie2Cover> getHdMovie2List(dom.Element element)
  {
    List<HdMovie2Cover> coverList = [];
    List<dom.Element> postElementList = element.querySelectorAll(".item.movies");

    for(dom.Element postElement in postElementList)
      {
        String? title = postElement.querySelector(".data a")!.text;
        String? url = postElement.querySelector(".data a")!.attributes["href"];
        String? tag1 = postElement.querySelector(".data span")!.text;
        if(tag1.contains(","))
          {
            tag1 = tag1.split(",").last.trim();
          }
        String? posterUrl = postElement.querySelector(".poster img")!.attributes["data-wpfc-original-src"];
        String? tag2 = postElement.querySelector(".poster .rating")!.text;
        coverList.add(HdMovie2Cover(title: title,url: url,imageURL: posterUrl,tag1: tag1,tag2: tag2));
      }

    return coverList;
  }

  Future<void> loadWatchSeriesHomeScreen() async
  {

    dom.Document pageDocument = await WebUtils.getDomFromURL_Get(WATCHSERIES_HOME_SERVER_URL);

    dom.Element topElement = pageDocument.querySelector(".section-id-top .film-list-ul")!;
    watchSeriesCategoryListMap[WatchSeriesHomeScreenCategoryEnum.Top.name] = SourceUtils.getWatchSeriesList(topElement);

    dom.Element trendingMoviesElement = pageDocument.querySelector(".section-id-01 #trending-movies .film_list-wrap")!;
    watchSeriesCategoryListMap[WatchSeriesHomeScreenCategoryEnum.Trending_Movies.name] = SourceUtils.getWatchSeriesList(trendingMoviesElement);

    dom.Element trendingTvShowsElement = pageDocument.querySelector(".section-id-01 #trending-tv .film_list-wrap")!;
    watchSeriesCategoryListMap[WatchSeriesHomeScreenCategoryEnum.Trending_Tv_Shows.name] = SourceUtils.getWatchSeriesList(trendingTvShowsElement);

    dom.Element latestMoviesElement = pageDocument.querySelector(".section-id-02 .film_list-wrap")!;
    watchSeriesCategoryListMap[WatchSeriesHomeScreenCategoryEnum.Latest_Movies.name] = SourceUtils.getWatchSeriesList(latestMoviesElement);

    dom.Element latestTvShowsElement = pageDocument.querySelector(".section-id-03 .film_list-wrap")!;
    watchSeriesCategoryListMap[WatchSeriesHomeScreenCategoryEnum.Latest_Tv_Shows.name] = SourceUtils.getWatchSeriesList(latestTvShowsElement);

    isWatchSeriesHomePageLoading.value = true;
  }


  Future<void> loadCineZoneHomeScreen() async
  {
    dom.Document pageDocument = await WebUtils.getDomFromURL_Get(CINEZONE_HOME_SERVER_URL);
    List<dom.Element> featuredList = pageDocument.querySelectorAll(".swiper.swiper-container.featured .swiper-wrapper .swiper-slide");
    List<CineZoneCover> featuredCoverList = [];
    for(dom.Element featuredElement in featuredList)
      {
        String? imgUrl = featuredElement.querySelector(".swiper-bg div img")!.attributes["src"];
        dom.Element? titleUrlElement = featuredElement.querySelector(".container .swiper-info .title");
        String? url = CINEZONE_SERVER_URL +  titleUrlElement!.attributes["href"]!;
        String? title = titleUrlElement.text;
        dom.Element? metaElement = featuredElement.querySelector(".container .swiper-info .meta");
        String? tag1 = metaElement!.querySelector(".rating")!.text.trim();
        String? tag2 = metaElement!.querySelectorAll("span")[1].text;
        featuredCoverList.add(CineZoneCover(url: url,tag2: tag2,tag1: tag1,title: title,imageURL: imgUrl));
      }
    cineZoneCategoryListMap[CineZoneHomeCategoryEnum.Featured.name] = featuredCoverList;

    dom.Element? recommendedMoviesElement = pageDocument.querySelector(".mt-4.default-sliderz div[data-name=\"movies\"] .lg-card]");
    cineZoneCategoryListMap[CineZoneHomeCategoryEnum.Recommended_Movies.name] = SourceUtils.getCineZoneList(recommendedMoviesElement!);

    dom.Element? recommendedSeriesElement = pageDocument.querySelector(".mt-4.default-sliderz div[data-name=\"series\"] .lg-card]");
    cineZoneCategoryListMap[CineZoneHomeCategoryEnum.Recommended_Tv_Shows.name] = SourceUtils.getCineZoneList(recommendedSeriesElement!);

    dom.Element? trendingElement = pageDocument.querySelector(".mt-4.default-sliderz div[data-name=\"trending\"] .lg-card]");
    cineZoneCategoryListMap[CineZoneHomeCategoryEnum.Trending.name] = SourceUtils.getCineZoneList(trendingElement!);

    List<dom.Element> latestList = pageDocument.querySelectorAll(".default-slider");

    for(dom.Element element in latestList)
      {
        String? title = element.querySelector(".head.border-b h2")!.text;
        dom.Element? latestElement = element.querySelector(".swiper.swiper-container.recommended-slider.lg-card .swiper-wrapper");
        switch (title.trim())
        {
          case "Latest Movies":
            cineZoneCategoryListMap[CineZoneHomeCategoryEnum.Latest_Movies.name] = SourceUtils.getCineZoneList(latestElement!);
          case "Latest TV Shows":
            cineZoneCategoryListMap[CineZoneHomeCategoryEnum.Latest_Tv_Shows.name] = SourceUtils.getCineZoneList(latestElement!);
        }
      }

    isCineZoneHomePageLoading.value = true;

   }

   Future<void> loadGokuHomeScreen () async
   {
     dom.Document pageDocument = await WebUtils.getDomFromURL_Get(GOKU_HOME_SERVER_URL);
     List<dom.Element> featuredElementList = pageDocument.querySelectorAll(".swiper-wrapper .swiper-slide .item-content");

     List<GokuCover> featuredCoverList = [];
     for(dom.Element featuredElement in featuredElementList)
       {
         String? url = GOKU_SERVER_URL + featuredElement.querySelector(".movie-thumbnail a")!.attributes["href"]!;
         String? posterUrl = featuredElement.querySelector(".movie-thumbnail a img")!.attributes["src"];
         String? title = featuredElement.querySelector(".movie-info a")!.text;
         String? tag1 = featuredElement.querySelector(".movie-info .info-split .is-rated")!.text.trim().replaceAll("\n", "");
         String? tag2 = featuredElement.querySelectorAll(".movie-info .info-split div")[2]!.text;
         featuredCoverList.add(GokuCover(url: url,tag2: tag2,tag1: tag1,title: title,imageURL: posterUrl));
       }

     gokuCategoryListMap[GokuHomeCategoryEnum.Featured.name] = featuredCoverList;

     dom.Element? trendinMoviesElement = pageDocument.querySelector("#trending-movies .section-items.section-items-default");
     gokuCategoryListMap[GokuHomeCategoryEnum.Trending_Movies.name] = SourceUtils.getGokuList(trendinMoviesElement!);

     dom.Element? trendinSeriesElement = pageDocument.querySelector("#trending-series .section-items.section-items-default");
     gokuCategoryListMap[GokuHomeCategoryEnum.Trending_Tv_Shows.name] = SourceUtils.getGokuList(trendinSeriesElement!);

     List<dom.Element> latestElementList = pageDocument.querySelectorAll(".section-row.section-padding.section-last");

     for(dom.Element latestElement in latestElementList)
       {
          String? key = latestElement.querySelector(".section-header .section-name")!.text;

          switch (key)
          {
            case "Latest Movies":
              dom.Element? latestMoviesElement = latestElement.querySelector(".section-items.section-items-default");
              gokuCategoryListMap[GokuHomeCategoryEnum.Latest_Movies.name] = SourceUtils.getGokuList(latestMoviesElement!);
            case "Latest TV Series":
              dom.Element? latestTvShowsElement = latestElement.querySelector(".section-items.section-items-default");
              gokuCategoryListMap[GokuHomeCategoryEnum.Latest_Tv_Shows.name] = SourceUtils.getGokuList(latestTvShowsElement!);
          }
       }

     isGokuHomePageLoading.value = true;

   }


}