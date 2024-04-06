
import 'package:Movieverse/controllers/main_screen_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/prime_wire_cover.dart';
import 'package:Movieverse/models/prime_wire_detail.dart';
import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class PrimeWireMovieDetailController extends GetxController
{
  late dom.Document movieDocument;
  MainScreenController mainScreenController = Get.put(MainScreenController());
  Future<PrimeWireDetail> getMovieDetail(PrimeWireCover primeWireCover) async
  {
    movieDocument = await WebUtils.getDomFromURL(primeWireCover.url!);
    List<dom.Element> list = movieDocument.querySelectorAll(".movie_info table tbody tr");
    String? description = list[0].querySelector("td p")!.text.trim();
    String? ratings = "",runtime = "",genre="",countries="",company="",cast="",crew="",releasedDate="";
    for(int i = 1;i<list.length;i++)
      {
        List<dom.Element> rowList = list[i].querySelectorAll("td strong")!;
        String? rowTitle = rowList.length> 0 ?rowList[0].text : "";

        switch(rowTitle) {
          case "Ratings:":
            ratings = rowList[1].text;
          case "Released:":
            releasedDate = list[i].querySelectorAll("td")[1].text.trim();
          case "Runtime:":
            runtime = list[i].querySelectorAll("td")[1].text.trim();
          case "Genres:":
            List<dom.Element> genreList = list[i].querySelectorAll(".movie_info_genres a");
            for(dom.Element element in genreList)
              {
                genre = genre! + element.text +" ";
              }
          case "Countries:":
            List<dom.Element> countryList = list[i].querySelectorAll(".movie_info_actors a");
            for(dom.Element element in countryList)
            {
              countries = countries! + element.text +" ";
            }
          case "Companies:":
            List<dom.Element> companyList = list[i].querySelectorAll(".movie_info_actors a");
            for(dom.Element element in companyList)
            {
              company = company! + element.text +" ";
            }
          case "Cast:":
            List<dom.Element> companyList = list[i].querySelectorAll(".movie_info_actors a");
            for(dom.Element element in companyList)
            {
              cast = cast! + element.text +" ";
            }
          case "Crew:":
            List<dom.Element> companyList = list[i].querySelectorAll(".movie_info_actors a");
            for(dom.Element element in companyList)
            {
              crew = crew! + element.text +" ";
            }
          default:
            break;
        }
      }
    print(list);
    return PrimeWireDetail(url: primeWireCover.url,title: primeWireCover.title,genre: genre,duration: runtime,description: description,coverUrl: primeWireCover.imageURL,country: countries,actors: cast,ratings: ratings,releasedDate: releasedDate,company: company,crew: crew);
  }


  Future<void> loadMovieInWebView(String? pageUrl) async
  {
    LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Fetching Server Links.....");
    await mainScreenController.webViewController.loadRequest(Uri.parse(pageUrl!));
  }

  // Future<Map<String,List<String>> >getServerPages() async
  // {
  //   String? html = await mainScreenController.getHtmlFromPrimewire();
  //   dom.Document document = HtmlParsingUtils.getDomfromHtml(html!);
  //   Map <String,List<String>> map = Map();
  //   List<dom.Element> list = document.querySelectorAll(".actual_tab .movie_version");
  //
  //   for(dom.Element element in list)
  //     {
  //       String source = element.querySelector(".version-host")!.text;
  //       String sourceUrl = PRIMEWIRE_HOST_SERVER_URL + element.querySelector(".go-link.propper-link.popper.ico-btn")!.attributes["data-wp-menu"]!;
  //       _addServerPage(source!,VideoHosterEnum.ePlayVid.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.Dood.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.DropLoad.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.FileLions.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.MixDrop.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.StreamTape.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.StreamVid.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.StreamWish.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.UpStream.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.VidMoly.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.Vidoza.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.VoeSX.name,map,sourceUrl!);
  //       _addServerPage(source!,VideoHosterEnum.VTubeTo.name,map,sourceUrl!);
  //     }
  //
  //   print(map);
  //
  //   return map;
  // }
  //
  //
  // void _addServerPage(String providerName,String hostProvider,Map<String,List<String>> map,String pageServerUrl)
  // {
  //   if(providerName!.contains(hostProvider))
  //   {
  //     if(map[hostProvider] == null)
  //     {
  //       List<String> list = [];
  //       list.add(pageServerUrl!);
  //       map[hostProvider] = list;
  //     }
  //     else
  //     {
  //       map[hostProvider]!.add(pageServerUrl!);
  //     }
  //   }
  // }

}