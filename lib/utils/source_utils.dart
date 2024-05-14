
import 'package:Movieverse/models/cinezone/cinezone_cover.dart';
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/goku/goku_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';
import 'package:Movieverse/models/watch_series/watch_series_cover.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:html/dom.dart' as dom;

class SourceUtils
{

  static final String WATCHSERIES_SERVER_URL = "https://watchseries.pe";
  static final String CINEZONE_SERVER_URL = "https://cinezone.to";
  static final String GOKU_SERVER_URL = "https://goku.sx";
  static List<PrMoviesCover> getPrMoviesCategoriesDetailList(dom.Element element)
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

  static List<Film1kCover> getFilm1kMoviesList(dom.Document document)
  {
    List<Film1kCover> film1kList = [];
    List<dom.Element> list = document.querySelectorAll(".loop-post.vdeo.snow-b.sw03.pd08.por.ovh");
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

  static List<WatchMoviesCover> getWatchMoviesList(dom.Element element)
  {
    List<WatchMoviesCover> coverList = [];
    List<dom.Element> list =  element.querySelectorAll(".postbox");

    for(dom.Element element2 in list)
      {
        try {
          String? title = LocalUtils.getStringBeforString("Watch", element2.querySelector("a")!.attributes["title"]!);
          String? url = element2.querySelector("a")!.attributes["href"];
          String? posterUrl = element2.querySelector("a img")!.attributes["data-src"];

          coverList.add(WatchMoviesCover(url: url,imageURL: posterUrl,title: title));
        } catch (e) {
          print(e);
        }
      }

    return coverList;
  }

  static List<WatchSeriesCover> getWatchSeriesList (dom.Element element)
  {
    List<dom.Element> listMovies = element.querySelectorAll(".flw-item");
    List<WatchSeriesCover> listMoviesCover = [];

    for (dom.Element movieElement in listMovies)
    {
      String? posterUrl = movieElement.querySelector(".film-poster img")!.attributes["src"] ?? movieElement.querySelector(".film-poster img")!.attributes["data-src"];
      String? url = WATCHSERIES_SERVER_URL + movieElement.querySelector(".film-poster a")!.attributes["href"]!;
      String? title = movieElement.querySelector(".film-detail .film-name a")!.text;
      String? tag1 = movieElement.querySelectorAll(".film-infor span")[1].text;
      String? tag2 = movieElement.querySelectorAll(".film-infor span")[2].text;
      listMoviesCover.add(WatchSeriesCover(url: url,title: title,imageURL: posterUrl,tag1: tag1,tag2: tag2));
    }
    return listMoviesCover;
  }

  static List<CineZoneCover> getCineZoneList (dom.Element element)
  {
    List<CineZoneCover> coverList = [];
    List<dom.Element> moviesList = element.querySelectorAll(".item .inner");

    for(dom.Element movieElement in moviesList)
      {
        String? posterUrl = movieElement.querySelector(".poster img")!.attributes["data-src"];
        dom.Element? urlTitleElement = movieElement!.querySelector(".info a");
        String? title = urlTitleElement!.text;
        String? url = CINEZONE_SERVER_URL + urlTitleElement!.attributes["href"]!;
        String? tags =  movieElement!.querySelector(".info .sub-info span")!.text;
        String? tag1 = tags.split("-")[0].trim();
        String? tag2 = tags.split("-")[1].trim();
        coverList.add(CineZoneCover(imageURL: posterUrl,title: title,tag1: tag1,tag2: tag2,url: url));
      }
    return coverList;
  }

  static List<GokuCover> getGokuList (dom.Element element)
  {
    List<GokuCover> coverList = [];
    List<dom.Element> coverElementList= element.querySelectorAll(".item");

    for(dom.Element coverElement in coverElementList)
      {
        String? posterUrl = coverElement.querySelector(".movie-thumbnail a img")!.attributes["src"];
        String? url = GOKU_SERVER_URL + coverElement.querySelector(".movie-thumbnail .pos-center .is-watch a")!.attributes["href"]!;
        String? title = coverElement.querySelector(".movie-info .movie-name")!.text;
        List<dom.Element> movieInfoList = coverElement.querySelectorAll(".info-split div");
        String? tag1 = movieInfoList[0]!.text;
        String? tag2 = movieInfoList[2]!.text;
        coverList.add(GokuCover(title: title,imageURL: posterUrl,tag1: tag1,tag2: tag2,url: url));
      }
    return coverList;
  }


}