

import 'package:Movieverse/models/m4u_free/m4ufree_cover.dart';
import 'package:Movieverse/models/m4u_free/m4ufree_detail.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class M4UFreeDetailController extends GetxController
{
  late dom.Document pageDocument;
  Future<M4UFreeDetail> getMovieDetail (M4UFreeCover m4uFreeCover) async
  {
    pageDocument = await WebUtils.getDomFromURL_Get(m4uFreeCover.url!);

    String? genre = "N/A", director = "N/A", country = "N/A", actors = "N/A", runtime = "N/A", description = "N/A", released = "N/A", quality = "N/A";

    List<dom.Element> infoElementList = pageDocument.querySelectorAll(".iteminfo .row .col-12.col-sm-6.pl-4.pb-2.pt-sm-4 .mvdt");

    description = pageDocument.querySelector("pre")!.text.replaceAll("Storyline:", "");
    for (dom.Element infoElement in infoElementList)
      {
        if(infoElement.nodes.length == 4)
          {
            infoElement.nodes!.removeWhere((e)=> e.text!.isEmpty);
          }
        dom.NodeList infoNodeList = infoElement.nodes;
        String? key = infoNodeList[1]!.text!.trim();
        String? value = infoNodeList[2]!.text!.trim();
        switch(key)
         {
          case "Quality:":
            quality = value;
          case "Director:":
            director = value;
          case "Genre:":
            genre = value;
          case "Quality:":
            quality = value;
          case "Country:":
            country = value;
          case "Runtime:":
            runtime = value;
          case "Released:":
            released = value;
          case "Starring:":
            actors = LocalUtils.removeExtraWhiteSpaceBetweenWords(value);
        }
      }

    return M4UFreeDetail(url: m4uFreeCover.url,title: m4uFreeCover.title,actors: actors,country: country,coverUrl: m4uFreeCover.imageURL,description: description,director: director,genre: genre,quality: quality,released: released,runtime: runtime,);


  }
}