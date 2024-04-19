
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:html/dom.dart' as dom;

class SourceUtils
{
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
}