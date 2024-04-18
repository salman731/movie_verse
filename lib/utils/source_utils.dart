
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
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
}