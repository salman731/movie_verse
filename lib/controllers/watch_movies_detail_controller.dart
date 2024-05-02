
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/enums/video_resolution_enum.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_detail.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;


class WatchMoviesDetailController extends GetxController
{
  late dom.Document pageDocument;
  final String WATCHMOVIES_SERVER_URL = "https://www.watch-movies.com.pk";



  Future<WatchMoviesDetail> getMoviesDetail(WatchMoviesCover watchMoviesCover) async
  {
     pageDocument = await WebUtils.getDomFromURL_Get(watchMoviesCover.url!);

      List<dom.Element> list = pageDocument.querySelectorAll(".rightinfo p");

      String genre = "N/A",addedDate = "N/A",views = "N/A",director = "N/A",duration = "N/A";

      for(dom.Element element in list)
        {
          if(element.text.contains("Genres :"))
          {
            genre = element.text.split(":")[1];
          }
          if(element.text.contains("Added on :"))
            {
              addedDate = element.text.split(":")[1];
            }
        }

      views = pageDocument.querySelector(".viewsforvid p span span")!.text;

      director = pageDocument.querySelector(".rightdirdur span[itemprop=\"name\"]")!.text;
      duration = pageDocument.querySelector(".rightdirdur span[itemprop=\"duration\"]")!.text;

      return WatchMoviesDetail(title: watchMoviesCover.title,url: watchMoviesCover.url,coverUrl: watchMoviesCover.imageURL,director: director,genre: genre,addedDate: addedDate,duration: duration,views: views );


  }
  
  Map<String,Map<String,String>> getServerPages ()
  {
    List<dom.Element> iframeList =  pageDocument.querySelectorAll(".singcont p a");
    Map<String,Map<String,String>> map = Map();
    for(dom.Element element in iframeList)
      {
        String? src = element.attributes["href"];

        for(VideoHosterEnum videoHosterEnum in VideoHosterEnum.values)
          {
            _addServerPage(src!, videoHosterEnum.name, map, src,element.text);
          }
      }
    return map;
   }

  void _addServerPage(String providerName,String hostProvider,Map<String,Map<String,String>> map,String pageServerUrl,String quality)
  {
    if(providerName.toLowerCase()!.contains(hostProvider.toLowerCase()))
    {
      if(map[hostProvider] == null)
      {
        Map<String,String> map2 = Map();
        for (String resolution in VideoResolutionEnum.list)
          {
            if(quality.contains(resolution))
              {
                map2[resolution] = pageServerUrl;
              }
          }
        if(map2.isEmpty && pageServerUrl.isNotEmpty)
          {
            map2["HD"] = pageServerUrl;
          }
        map[hostProvider] = map2;
      }
      else
      {
        Map<String,String>? map3 = map[hostProvider];
        for (String resolution in VideoResolutionEnum.list)
        {
          if(quality.contains(resolution))
          {
            map3![resolution] = pageServerUrl;
          }
        }
        map[hostProvider] = map3!;
      }
    }
  }

  }
