


import 'package:Movieverse/controllers/film_1k_detail_controller.dart';
import 'package:Movieverse/controllers/main_screen_controller.dart';
import 'package:Movieverse/controllers/primewire_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/screens/film_1k_movie_detail.dart';
import 'package:Movieverse/screens/primewire_movie_detail_screen.dart';
import 'package:Movieverse/utils/colors_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:Movieverse/screens/up_movie_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:show_loader_dialog/show_loader_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';



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
    mainScreenController.initWebViewController();
    mainScreenController.upMoviesScrollController.addListener(() {
      if (mainScreenController.upMoviesScrollController.position.extentAfter == 0) {
        mainScreenController.loadMoviesfromUpMovies(searchEditingController.text,loadMore: true);
      }
    });
    mainScreenController.primeWireScrollController.addListener(() {
      if (mainScreenController.primeWireScrollController.position.extentAfter == 0) {
        mainScreenController.loadPrimeWireMovies(searchEditingController.text,isLoadMore: true);
      }
    });

    mainScreenController.film1kScrollController.addListener(() {
      if (mainScreenController.film1kScrollController.position.extentAfter == 0) {
        mainScreenController.loadFilm1KMovies(searchEditingController.text,isLoadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          /*floatingActionButton: FloatingActionButton(onPressed: () async {
            String embededUrl = "https:\/\/vidhidevip.com\/v\/cssj8cpxssit";
            VideoHostProviderUtils.getM3U8UrlFromVidHideVip(embededUrl, "title",headers: {"Referer":"https://www.film1k.com/"});
            // mainScreenController.webViewController.runJavaScript(""
            //     "document.getElementById(\"search_term\").value = \"road\";"
            //     "const bton = document.querySelector(\".search_container button\");"
            //     "bton.click();");
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
          body: Obx(()=> mainScreenController.isSearchStarted.value ? SingleChildScrollView(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height:0,width:0,child: WebViewWidget(controller: mainScreenController.webViewController,)),
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
                                      Get.to(UpMovieDetailScreen(mainScreenController.upMoviesSearchList[index]));
                                      //await mainScreenController.getMovieDetail(mainScreenController.upMoviesSearchList[index]);

                                    },
                                    child: _movieSingleItem(mainScreenController.upMoviesSearchList[index].title!,mainScreenController.upMoviesSearchList[index].imageURL!),
                                  ),
                                ),
                              ),
                            ),
                            if (mainScreenController.isUpMovieMoreUpMoviesLoading.value) Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Transform.scale(scale: 0.5,child: CircularProgressIndicator(color: AppColors.kPrimaryColor,)),
                              ),
                            ),
                          ],
                        )) ,
                      ),
                      Align(alignment:Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Primewire",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                      )),
                      SizedBox(
                        height: 200.0,
                        child: Obx(()=> mainScreenController.isPrimeWireSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,),) : Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                controller: mainScreenController.primeWireScrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: mainScreenController.primeWireSearchList.length,
                                itemBuilder: (BuildContext context, int index) => SizedBox(
                                  width: 100,
                                  height: 200,
                                  child: InkWell(
                                    onTap: () async {
                                      /*PrimeWireMovieDetailController controller = Get.put(PrimeWireMovieDetailController());
                                      controller.getMovieDetail(mainScreenController.primeWireSearchList[index]);*/
                                      mainScreenController.primewireMovieTitle = mainScreenController.primeWireSearchList[index].title;
                                      Get.to(PrimeWireMovieDetailScreen(mainScreenController.primeWireSearchList[index]));
                                      //await mainScreenController.getMovieDetail(mainScreenController.upMoviesSearchList[index]);

                                    },
                                    child: _movieSingleItem(mainScreenController.primeWireSearchList[index].title!,mainScreenController.primeWireSearchList[index].imageURL!),
                                  ),
                                ),
                              ),
                            ),
                            if (mainScreenController.isPrimeWireMoreUpMoviesLoading.value) Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Transform.scale(scale: 0.5,child: CircularProgressIndicator(color: AppColors.kPrimaryColor,)),
                              ),
                            ),
                          ],
                        )) ,
                      ),
                      Align(alignment:Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Film1k",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                      )),
                      SizedBox(
                        height: 200.0,
                        child: Obx(()=> mainScreenController.isFilm1kSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,),) : Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                controller: mainScreenController.film1kScrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: mainScreenController.film1kSearchList.length,
                                itemBuilder: (BuildContext context, int index) => SizedBox(
                                  width: 100,
                                  height: 200,
                                  child: InkWell(
                                    onTap: () async {
                                      Get.to(Film1kDetailScreen(mainScreenController.film1kSearchList[index]));
                                    },
                                    child: _movieSingleItem(mainScreenController.film1kSearchList[index].title!,mainScreenController.film1kSearchList[index].imageURL!),
                                  ),
                                ),
                              ),
                            ),
                            if (mainScreenController.isFilm1kMoreUpMoviesLoading.value) Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Transform.scale(scale: 0.5,child: CircularProgressIndicator(color: AppColors.kPrimaryColor,)),
                              ),
                            ),
                          ],
                        )) ,
                      )
                    ],
                  ),
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
        mainScreenController.startShowingLoadingSources();
        await mainScreenController.loadMoviesfromUpMovies(searchEditingController.text);
        await mainScreenController.loadPrimeWireMovies(searchEditingController.text);
        await mainScreenController.loadFilm1KMovies(searchEditingController.text);

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
