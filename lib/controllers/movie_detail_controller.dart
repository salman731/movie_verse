
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class MovieDetailController extends GetxController
{
  late dom.Document moviePageDocument;
  late dom.Document episodePageDocument;
  Map<int,String> episodeMap = Map();
  RxInt selectedEpisode = 0.obs;
  bool checkifEpisodeExist = false;
  Future<UpMovieDetail>? getMovieDetail(UpMoviesCover upMoviesCover) async
  {
    moviePageDocument = await HtmlParsingUtils.getDomFromURL(upMoviesCover.url!);
    List<dom.Element> list = moviePageDocument.querySelectorAll(".film-detail-right .film-detail .about .features ul li");
    String genre = LocalUtils.getStringAfterStartStringToEnd("Genres: ", list[0].text);
    String country = LocalUtils.getStringAfterStartStringToEnd("Country: ", list[1].text);
    String director = LocalUtils.getStringAfterStartStringToEnd("Director: ", list[2].text);
    String duration = LocalUtils.getStringAfterStartStringToEnd("Duration: ", list[3].text);
    String year = LocalUtils.getStringAfterStartStringToEnd("Year: ", list[4].text);
    String actors = LocalUtils.getStringAfterStartStringToEnd("Actors: ", list[5].text);
    String? description = moviePageDocument.querySelector(".film-detail-right .film-detail .textSpoiler")!.text.trim();
    checkIfEpisodeExist();
    if(checkifEpisodeExist)
      {
        selectedEpisode.value = 1;
        episodeMap = getEpisodeServerPagesOfSeries();
      }
    return UpMovieDetail(year: year,url: upMoviesCover.url,title: upMoviesCover.title,actors: actors,country: country,coverUrl: upMoviesCover.imageURL,description: description,director: director,duration: duration,genre: genre);
  }

  Future<Map<String,List<String>> >getServerPages({String? episodePageUrl,bool isSeries = false}) async
  {
    Map <String,List<String>> map = Map();
    List<dom.Element> list;
    if(isSeries)
      {
        episodePageDocument = await HtmlParsingUtils.getDomFromURL(episodePageUrl!);
        list = episodePageDocument.getElementsByClassName("server_line");
      }
    else
      {
        list = moviePageDocument.getElementsByClassName("server_line");
      }

    for(int i = 0;i<list.length;i++)
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
      }
    return map;
  }


  void _addServerPage(String providerLogoImageUrl,String hostProvider,Map<String,List<String>> map,String pageServerUrl)
  {
    if(providerLogoImageUrl!.contains(hostProvider))
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

  void checkIfEpisodeExist()
  {
    List<dom.Element> list = moviePageDocument.querySelectorAll("#cont_player #details a");
    checkifEpisodeExist = list != null && list.isNotEmpty;
  }

  Map<int,String> getEpisodeServerPagesOfSeries()
  {
    Map<int,String> map = Map();
    List<dom.Element> list = moviePageDocument.querySelectorAll("#cont_player #details a");
    for(int i = 0;i<list.length;i++)
      {
        map[int.parse(list[i].text)] = list[i].attributes["href"]!;
      }
    return map;
  }
}