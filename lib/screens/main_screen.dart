

import 'package:Movieverse/controllers/main_screen_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:Movieverse/screens/movie_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:show_loader_dialog/show_loader_dialog.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  MainScreenController mainScreenController = Get.put(MainScreenController());
  TextEditingController searchEditingController = TextEditingController();
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;


  @override
  void initState() {
    mainScreenController.upMoviesScrollController.addListener(() {
      if (mainScreenController.upMoviesScrollController.position.extentAfter == 0) {
        mainScreenController.loadMoviesfromUpMovies(searchEditingController.text,loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          /*floatingActionButton: FloatingActionButton(onPressed: () async {

           // LoaderDialog.showLoaderDialog(navigatorKey.currentContext!);
           // await Future.delayed(Duration(seconds: 3));
           // LoaderDialog.stopLoaderDialog();

          },child: Icon(Icons.add)),*/
          appBar: AppBar(title: !_isSearching ? Text("Main Screen") : _searchTextField(),
          actions: !_isSearching ? [IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              }),] : [
            IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                  });
                }
            ),

          ] ,),
          body: Obx(()=> mainScreenController.isSearchStarted.value ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(alignment:Alignment.centerLeft,child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Up Source",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                    )),
                    SizedBox(
                      height: 200.0,
                      child: Obx(()=> mainScreenController.isUpMoviesSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,),) : Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              controller: mainScreenController.upMoviesScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: mainScreenController.upMoviesSearchList.length,
                              itemBuilder: (BuildContext context, int index) => SizedBox(
                                width: 100,
                                height: 200,
                                child: InkWell(
                                  onTap: () async {
                                    Get.to(MovieDetailScreen(mainScreenController.upMoviesSearchList[index]));
                                    //await mainScreenController.getMovieDetail(mainScreenController.upMoviesSearchList[index]);

                                  },
                                  child: _movieSingleItem(mainScreenController.upMoviesSearchList[index].title!,mainScreenController.upMoviesSearchList[index].imageURL!),
                                ),
                              ),
                            ),
                          ),
                          if (mainScreenController.isMoreUpMoviesLoading.value) Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      )) ,
                    )
                  ],
                ) : Container(),
          ),
        ));
  }
  
  Widget _movieSingleItem(String title,String imgUrl)
  {
    return Card(
      child: Column(children: [
        SizedBox(height:130,child: Image.network(imgUrl,fit: BoxFit.fill,)),
        SizedBox(height:10,),
        Text(title,maxLines: 2,textAlign: TextAlign.center,)
      ],),
    ) ;
  }
  
  Widget _searchTextField() {
    return TextField(
      autofocus: false,
      cursorColor: Colors.white,
      controller: searchEditingController,
      onSubmitted: (value) async
      {
        mainScreenController.isSearchStarted.value = true;
        await mainScreenController.loadMoviesfromUpMovies(searchEditingController.text);

      },
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.movie,color: Colors.white,),
        suffixIcon: InkWell(
          onTap: () {
            searchEditingController.clear();
          },
          child: const Icon(
            Icons.clear,
            size: 24,
            color: Colors.deepOrange,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'What movie you want to watch.....',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
}
