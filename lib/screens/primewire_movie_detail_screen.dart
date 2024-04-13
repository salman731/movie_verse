

import 'package:Movieverse/controllers/main_screen_controller.dart';
import 'package:Movieverse/controllers/primewire_movie_detail_controller.dart';
import 'package:Movieverse/controllers/up_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/enums/media_type_enum.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/prime_wire_cover.dart';
import 'package:Movieverse/models/prime_wire_detail.dart';
import 'package:Movieverse/models/primewire_season_episode.dart';
import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/utils/colors_utils.dart';
import 'package:Movieverse/widgets/play_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimeWireMovieDetailScreen extends StatefulWidget {
  PrimeWireCover primeWireCover;
  PrimeWireMovieDetailScreen(this.primeWireCover,{super.key});

  @override
  State<PrimeWireMovieDetailScreen> createState() => _PrimeWireMovieDetailScreenState();
}

class _PrimeWireMovieDetailScreenState extends State<PrimeWireMovieDetailScreen> {

  PrimeWireMovieDetailController primeWireMovieDetailController = Get.put(PrimeWireMovieDetailController());
  SearchScreenController searchScreenController = Get.put(SearchScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.primeWireCover.title!),),
      body: FutureBuilder<PrimeWireDetail>(
        future: primeWireMovieDetailController.getMovieDetail(widget.primeWireCover!)!,
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
                    getTextWidget("Genre : ",snapshot.data!.genre!),
                    SizedBox(height: 5,),
                    getTextWidget("Country : ",snapshot.data!.country!),
                    SizedBox(height: 5,),
                    getTextWidget("Crew : ",snapshot.data!.crew!),
                    SizedBox(height: 5,),
                    getTextWidget("Duration : ",snapshot.data!.duration!),
                    SizedBox(height: 5,),
                    getTextWidget("Actors : ",snapshot.data!.actors!),
                    SizedBox(height: 5,),
                    getTextWidget("Realeased Date : ",snapshot.data!.releasedDate!),
                    SizedBox(height: 5,),
                    getTextWidget("Ratings : ",snapshot.data!.ratings!),
                    SizedBox(height: 5,),
                    getTextWidget("Companies : ",snapshot.data!.company!),
                    SizedBox(height: 5,),
                    getTextWidget("Description : ",snapshot.data!.description!),

                  ],),
                if(widget.primeWireCover.url!.contains("/tv/"))...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 8),
                    child: Align(alignment: Alignment.centerLeft,child: Text("Select Season :")),
                  ),
                  Obx(()=> SizedBox(
                    width: MediaQuery.of(context).size.width / 1.15,
                    child: DropdownButton<String>(
                      isExpanded:true,
                      value: primeWireMovieDetailController.selectedSeason.value,
                      items: snapshot.data!.seasonEpisodesMap!.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text("Season ${value}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        primeWireMovieDetailController.selectedEpisode.value = snapshot.data!.seasonEpisodesMap![value]![0];
                        primeWireMovieDetailController.selectedSeason.value = value!;
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
                    child: DropdownButton<PrimewireSeasonEpisode>(
                      isExpanded:true,
                      value: primeWireMovieDetailController.selectedEpisode.value,
                      items: snapshot.data!.seasonEpisodesMap![primeWireMovieDetailController.selectedSeason.value]?.map((PrimewireSeasonEpisode value) {
                        return DropdownMenuItem<PrimewireSeasonEpisode>(
                          value: value,
                          child: Text("${value.episodeNo} ${value.episodeTitle}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        primeWireMovieDetailController.selectedEpisode.value = value!;
                      },
                    ),
                  ),
                  ),
                ],
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.15,
                  child:PlayButton(onPress: () async {
                    if(primeWireMovieDetailController.mediaTypeEnum == MediaTypeEnum.Movie)
                    {
                      primeWireMovieDetailController.loadMovieInWebView(widget.primeWireCover.url);
                    }
                    else
                    {
                      primeWireMovieDetailController.loadMovieInWebView(primeWireMovieDetailController.selectedEpisode.value.episodeUrl);
                    }
                  }),
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
