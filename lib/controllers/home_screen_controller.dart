

import 'package:Movieverse/constants/priwewire_category_urls_contants.dart';
import 'package:Movieverse/enums/all_movie_land_home_category_enum.dart';
import 'package:Movieverse/enums/pr_movies_home_category_enum.dart';
import 'package:Movieverse/enums/primewire_home_screen_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/models/up_movies/up_movies_cover.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class HomeScreenController extends GetxController
{
  final String UPMOVIES_SERVER_URL = "https://www.upmovies.net";
  final String PRIMEWIRE_SERVER_URL = "https://www.primewire.tf";
  final String AllMOVIELAND_SERVER_URL = "https://allmovieland.fun";
  final String PRMOVIES_SERVER_URL = "https://prmovies.rent";
  Map<String,List<UpMoviesCover>> upMoviesCategoryListMap = <String,List<UpMoviesCover>>{};
  Map<String,List<PrimeWireCover>> primewireCategoryListMap = <String,List<PrimeWireCover>>{};
  Map<String,List<AllMovieLandCover>> allMovieLandCategoryListMap = <String,List<AllMovieLandCover>>{};
  Map<String,List<PrMoviesCover>> prMoviesCategoryListMap = <String,List<PrMoviesCover>>{};
  Rx<SourceEnum> selectedSource = SourceEnum.PrMovies.obs;


  Future<Map<String,List<UpMoviesCover>>> loadUpMoviesHomeScreen() async
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

     return upMoviesCategoryListMap;

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

  Future<Map<String,List<PrimeWireCover>>> loadPrimewireHomeScreen() async
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
      return primewireCategoryListMap;
   }

  Future<Map<String,List<AllMovieLandCover>>> loadAllMovieLandHomeScreen() async
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

    return allMovieLandCategoryListMap;

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

  Future<Map<String,List<PrMoviesCover>>> loadPrMoviesHomeScreen() async
  {
    dom.Document sourceDocument = await WebUtils.getDomFromURL_Get(PRMOVIES_SERVER_URL);
    dom.Element featuredElement = sourceDocument.querySelector("#movie-featured")!;
    dom.Element topIMDBElement = sourceDocument.querySelector("#top-imdb")!;
    prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Featured.name] = getPrMoviesCategoriesDetailList(featuredElement);
    prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.TopIMDB.name] = getPrMoviesCategoriesDetailList(topIMDBElement);

    List<dom.Element> categoryElementList = sourceDocument.querySelectorAll(".movies-list-wrap.mlw-latestmovie");
    
    for(dom.Element element in categoryElementList)
      {
        String? categoryTitle = element.querySelector(".ml-title .pull-left")!.text.trim();

        switch(categoryTitle)
         {
          case "Cinema Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Cinema.name] = getPrMoviesCategoriesDetailList(element);
          case "Bollywood Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Bollywood.name] = getPrMoviesCategoriesDetailList(element);
          case "Dual Audio Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.DualAudioMovies.name] = getPrMoviesCategoriesDetailList(element);
          case "Hot Series":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.HotSeries.name] = getPrMoviesCategoriesDetailList(element);
          case "Hollywood Movies":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.Hollywood.name] = getPrMoviesCategoriesDetailList(element);
          case "English Series":
            prMoviesCategoryListMap[PrMoviesHomeScreenCategoryEnum.EnglishSeries.name] = getPrMoviesCategoriesDetailList(element);
        }
      }
    return prMoviesCategoryListMap;
  }


  List<PrMoviesCover> getPrMoviesCategoriesDetailList(dom.Element element)
  {
     List<dom.Element> list = element.querySelectorAll(".ml-item");
     List<PrMoviesCover> prMoviesCoverList = [];
     for(dom.Element element2 in list)
       {
          String? title = element2.querySelector(".mli-info h2")!.text;
          String? url = element2.querySelector(".ml-mask,jt")!.attributes["href"];
          String? posterUrl = element2.querySelector(".lazy.thumb.mli-thumb")!.attributes["data-original"];
          String? tag = element2.querySelector(".mli-quality") != null ? element2.querySelector(".mli-quality")!.text : "";
          prMoviesCoverList.add(PrMoviesCover(title: title,url: url,imageURL: posterUrl,tag: tag));
       }
     return prMoviesCoverList;

  }

}