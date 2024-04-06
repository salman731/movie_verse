

import 'package:Movieverse/controllers/main_screen_controller.dart';
import 'package:Movieverse/controllers/primewire_movie_detail_controller.dart';
import 'package:Movieverse/controllers/up_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/prime_wire_cover.dart';
import 'package:Movieverse/models/prime_wire_detail.dart';
import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/utils/colors_utils.dart';
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
  MainScreenController mainScreenController = Get.put(MainScreenController());
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
                // if(movieDetailController.checkifEpisodeExist)...[
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 8),
                //     child: Align(alignment: Alignment.centerLeft,child: Text("Select Episode :")),
                //   ),
                //   Obx(()=> SizedBox(
                //     width: MediaQuery.of(context).size.width / 1.15,
                //     child: DropdownButton<int>(
                //       isExpanded:true,
                //       value: movieDetailController.selectedEpisode.value,
                //       items: movieDetailController.episodeMap.keys.map((int value) {
                //         return DropdownMenuItem<int>(
                //           value: value,
                //           child: Text("${value}"),
                //         );
                //       }).toList(),
                //       onChanged: (value) {
                //         movieDetailController.selectedEpisode.value = value!;
                //       },
                //     ),
                //   ),
                //   ),
                // ],
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.15,
                  child: OutlinedButton(onPressed: () async {
                    primeWireMovieDetailController.loadMovieInWebView(widget.primeWireCover.url);
                    // if(!movieDetailController.checkifEpisodeExist)
                    // {
                    //   ServerListDialog.showServerListDialog(navigatorKey.currentContext!, await movieDetailController.getServerPages(),widget.upMoviesCover.title!);
                    // }
                    // else
                    // {
                    //   ServerListDialog.showServerListDialog(navigatorKey.currentContext!, await movieDetailController.getServerPages(episodePageUrl: movieDetailController.episodeMap[movieDetailController.selectedEpisode],isSeries: true),widget.upMoviesCover.title!);
                    // }
                  }, child: Text("Play"),style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),),
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

  List<Widget> getServerLinksButtons()
  {
    OutlinedButton(onPressed: (){

    }, child: Text("Vip Server 1"));
    return [];
  }
}
