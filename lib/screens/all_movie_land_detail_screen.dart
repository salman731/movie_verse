
import 'package:Movieverse/controllers/all_movie_land_detail_controller.dart';
import 'package:Movieverse/controllers/film_1k_detail_controller.dart';
import 'package:Movieverse/controllers/up_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_detail.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_server_links.dart';
import 'package:Movieverse/models/film_1k_cover.dart';
import 'package:Movieverse/models/film_1k_detail.dart';
import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/utils/colors_utils.dart';
import 'package:Movieverse/widgets/play_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllMovieLandDetailScreen extends StatefulWidget {
  AllMovieLandCover allMovieLandCover;
  AllMovieLandDetailScreen(this.allMovieLandCover,{super.key});

  @override
  State<AllMovieLandDetailScreen> createState() => _AllMovieLandDetailScreenState();
}

class _AllMovieLandDetailScreenState extends State<AllMovieLandDetailScreen> {

  AllMovieLandDetailController allMovieLandDetailController = Get.put(AllMovieLandDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.allMovieLandCover.title!),),
      body: FutureBuilder<AllMovieLandDetail>(
        future: allMovieLandDetailController.getMovieDetail(widget.allMovieLandCover)!,
        builder: (context, snapshot) {
          if(snapshot.hasData)
          {
            return SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                    width: 150 ,
                    height: 275,
                    child: Image.network(snapshot.data!.imageURL!,fit: BoxFit.contain)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getTextWidget("Name : ",snapshot.data!.title!),
                    SizedBox(height: 5,),
                    getTextWidget("Orginal Name : ",snapshot.data!.orginalName!),
                    SizedBox(height: 5,),
                    getTextWidget("Country : ",snapshot.data!.country!),
                    SizedBox(height: 5,),
                    getTextWidget("Director : ",snapshot.data!.director!),
                    SizedBox(height: 5,),
                    getTextWidget("Duration : ",snapshot.data!.runtime!),
                    SizedBox(height: 5,),
                    getTextWidget("Actors : ",snapshot.data!.actors!),
                    SizedBox(height: 5,),
                    getTextWidget("Orginal Language : ",snapshot.data!.oringalLanguage!),
                    SizedBox(height: 5,),
                    getTextWidget("Translation Language : ",snapshot.data!.translationLanguage!),
                    SizedBox(height: 5,),
                    getTextWidget("Description : ",snapshot.data!.description!),

                  ],),
                if(allMovieLandDetailController.isSeries)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 8),
                    child: Align(alignment: Alignment.centerLeft,child: Text("Select Season :")),
                  ),
                  Obx(()=> SizedBox(
                    width: MediaQuery.of(context).size.width / 1.15,
                    child: DropdownButton<String>(
                      isExpanded:true,
                      value: allMovieLandDetailController.selectedSeason.value,
                      items: snapshot.data!.seasonEpisodeMap!.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text("Season ${value}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        allMovieLandDetailController.selectedEpisode.value = snapshot.data!.seasonEpisodeMap![value]![0];
                        allMovieLandDetailController.selectedSeason.value = value!;
                        allMovieLandDetailController.findSelectedSeasonEpisode();
                      },
                    ),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 8),
                    child: Align(alignment: Alignment.centerLeft,child: Text("Select Episode :")),
                  ),
                  Obx(()=> SizedBox(
                    width: MediaQuery.of(context).size.width / 1.15,
                    child: DropdownButton<String>(
                      isExpanded:true,
                      value: allMovieLandDetailController.selectedEpisode.value,
                      items: snapshot.data!.seasonEpisodeMap![allMovieLandDetailController.selectedSeason.value]?.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text("Episode ${value}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        allMovieLandDetailController.selectedEpisode.value = value!;
                        allMovieLandDetailController.findSelectedSeasonEpisode();
                      },
                    ),
                  ),
                  ),
                ],
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.15,
                  child: PlayButton(onPress: () async {
                    LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Fetching Server Links.....");
                    List<AllMovieLandServerLinks> list = await allMovieLandDetailController.getServerLinks();
                    LoaderDialog.stopLoaderDialog();
                    String title = "";
                    if(allMovieLandDetailController.isSeries)
                      {
                        title = widget.allMovieLandCover.title! + " Season ${allMovieLandDetailController.selectedSeason} Episode ${allMovieLandDetailController.selectedEpisode}";
                      }
                    else
                      {
                        title = widget.allMovieLandCover.title!;
                      }
                    ServerListDialog.showServerLinksDialog_AllMovieLand(navigatorKey.currentContext!,list , widget.allMovieLandCover.title!);
                  },),
                )
              ],),);
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  getTextWidget(String title,String description)
  {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex:3,child: Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)),
          Expanded(flex:7,child: Text(description,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),)),
        ],),
    );
  }

}
