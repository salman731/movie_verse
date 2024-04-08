
import 'package:Movieverse/controllers/film_1k_detail_controller.dart';
import 'package:Movieverse/controllers/up_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/film_1k_cover.dart';
import 'package:Movieverse/models/film_1k_detail.dart';
import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Film1kDetailScreen extends StatefulWidget {
  Film1kCover  film1kCover;
  Film1kDetailScreen(this.film1kCover,{super.key});

  @override
  State<Film1kDetailScreen> createState() => _Film1kDetailScreenState();
}

class _Film1kDetailScreenState extends State<Film1kDetailScreen> {

  Film1kController film1kController = Get.put(Film1kController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.film1kCover.title!),),
      body: FutureBuilder<Film1kDetail>(
        future: film1kController.getMovieDetail(widget.film1kCover)!,
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
                    getTextWidget("Director : ",snapshot.data!.director!),
                    SizedBox(height: 5,),
                    getTextWidget("Duration : ",snapshot.data!.runtime!),
                    SizedBox(height: 5,),
                    getTextWidget("Actors : ",snapshot.data!.actors!),
                    SizedBox(height: 5,),
                    getTextWidget("Released : ",snapshot.data!.released!),
                    SizedBox(height: 5,),
                    getTextWidget("Language : ",snapshot.data!.language!),
                    SizedBox(height: 5,),
                    getTextWidget("Description : ",snapshot.data!.description!),

                  ],),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.15,
                  child: OutlinedButton(onPressed: () async {
                    //await film1kController.getServerPages();

                    ServerListDialog.showServerListDialog(navigatorKey.currentContext!, await film1kController.getServerPages(),widget.film1kCover.title!,isDirectProviderLink: true,headers: {"Referer":"https://www.film1k.com/"});

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

}
