import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/search_screen_controller.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/screens/search_screen/screen_layout.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:Movieverse/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  SearchScreenController searchScreenController = Get.put(SearchScreenController());
  TextEditingController searchEditingController = TextEditingController();
  bool _isSearching = false;


  @override
  void initState() {
    super.initState();

    searchScreenController.initWebViewController();
    searchScreenController.upMoviesScrollController.addListener(() {
      if (searchScreenController.upMoviesScrollController.position.extentAfter == 0) {
        searchScreenController.isUpMovieMoreUpMoviesLoading.value = true;
        searchScreenController.loadMoviesfromUpMovies(searchEditingController.text,loadMore: true);
      }
    });
    searchScreenController.primeWireScrollController.addListener(() {
      if (searchScreenController.primeWireScrollController.position.extentAfter == 0) {
        searchScreenController.isPrimeWireMoreUpMoviesLoading.value = true;
        searchScreenController.loadPrimeWireMovies(searchEditingController.text,isLoadMore: true);
      }
    });

    searchScreenController.film1kScrollController.addListener(() {
      if (searchScreenController.film1kScrollController.position.extentAfter == 0) {
        searchScreenController.loadFilm1KMovies(searchEditingController.text,isLoadMore: true);
      }
    });
    searchScreenController.allMovieLandScrollController.addListener(() {
      if (searchScreenController.allMovieLandScrollController.position.extentAfter == 0) {
        searchScreenController.isAllMovieLandMoviesLoading.value = true;
        searchScreenController.loadAllMovieLand(searchEditingController.text,loadMore: true);
      }
    });
    searchScreenController.prMoviesScrollController.addListener(() {
      if (searchScreenController.prMoviesScrollController.position.extentAfter == 0) {
        searchScreenController.loadPrMoviesMovies(searchEditingController.text,isLoadMore: true);
      }
    });
    searchScreenController.watchMoviesScrollController.addListener(() {
      if (searchScreenController.watchMoviesScrollController.position.extentAfter == 0) {
        searchScreenController.loadWatchMoviesSearchList(searchEditingController.text,isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
        CustomTextfield(
          hint: 'Search For A Movie ...',
          icon: FontAwesomeIcons.searchengin,
          textEditingController: searchEditingController,
          isSufix: true,
          onsubmit: (query) async {
            searchScreenController.isSearchStarted.value = true;
            searchScreenController.startShowingLoadingSources();
            await searchScreenController.loadMoviesfromUpMovies(searchEditingController.text);
            await searchScreenController.loadPrimeWireMovies(searchEditingController.text);
            await searchScreenController.loadFilm1KMovies(searchEditingController.text);
            await searchScreenController.loadAllMovieLand(searchEditingController.text);
            await searchScreenController.loadPrMoviesMovies(searchEditingController.text);
            await searchScreenController.loadWatchMoviesSearchList(searchEditingController.text);

          },
        ),
        SizedBox(
          height: 2.h,
        ),
                Obx(()=> searchScreenController.isSearchStarted.value ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height:0,width:0,child: WebViewWidget(controller: searchScreenController.webViewController!,)),
                          const CustomText(
                            title: 'Up Movies',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(() => searchScreenController.isUpMoviesSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,color: Colors.white,),) :
                            Row(
                              children: [
                                Expanded(
                                  flex:8,
                                  child: MovieListView(
                                    controller: searchScreenController.upMoviesScrollController,
                                    moviesList:  searchScreenController.upMoviesSearchList,
                                    hasReachedMax: searchScreenController.isUpMovieMoreUpMoviesLoading.value,
                                    sourceEnum: SourceEnum.UpMovies,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'PrimeWire',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(() => searchScreenController.isPrimeWireSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,color: Colors.white),) :
                          Row(
                            children: [
                              Expanded(
                                flex:8,
                                child: MovieListView(
                                  controller: searchScreenController.primeWireScrollController,
                                  moviesList:  searchScreenController.primeWireSearchList,
                                  hasReachedMax: searchScreenController.isPrimeWireMoreUpMoviesLoading.value,
                                  sourceEnum: SourceEnum.Primewire,
                                ),
                              ),
                            ],
                          ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'Film1k',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(() => searchScreenController.isFilm1kSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,color: Colors.white),) :
                          Row(
                            children: [
                              Expanded(
                                flex:8,
                                child: MovieListView(
                                  controller: searchScreenController.film1kScrollController,
                                  moviesList:  searchScreenController.film1kSearchList,
                                  hasReachedMax: searchScreenController.isFilm1kMoreUpMoviesLoading.value,
                                  sourceEnum: SourceEnum.Film1k,
                                ),
                              ),
                            ],
                          ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'AllMovieLand (Multilanguage)',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(() => searchScreenController.isAllMovieLandSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,color: Colors.white),) :
                          Row(
                            children: [
                              Expanded(
                                flex:8,
                                child: MovieListView(
                                  controller: searchScreenController.allMovieLandScrollController,
                                  moviesList:  searchScreenController.allMovieLandSearchList,
                                  hasReachedMax: searchScreenController.isAllMovieLandMoviesLoading.value,
                                  sourceEnum: SourceEnum.AllMovieLand,
                                ),
                              ),
                            ],
                          ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: "PrMovies",
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(() => searchScreenController.isPrMoviesSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,color: Colors.white),) :
                          Row(
                            children: [
                              Expanded(
                                flex:8,
                                child: MovieListView(
                                  controller: searchScreenController.prMoviesScrollController,
                                  moviesList:  searchScreenController.prMoviesSearchList,
                                  hasReachedMax: searchScreenController.isPrMoviesMoviesLoading.value,
                                  sourceEnum: SourceEnum.PrMovies,
                                ),
                              ),
                            ],
                          ),
                          ),
                  SizedBox(
                  height: 2.h,
                ),
                  const CustomText(
                    title: "WatchMovies",
                    size: 12,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Obx(() => searchScreenController.isWatchMoviesSourceLoading.value ? Center(child: CupertinoActivityIndicator(radius: 12,color: Colors.white),) :
                  Row(
                    children: [
                      Expanded(
                        flex:8,
                        child: MovieListView(
                          controller: searchScreenController.watchMoviesScrollController,
                          moviesList:  searchScreenController.watchMoviesSearchList,
                          hasReachedMax: searchScreenController.isWatchMoviesLoading.value,
                          sourceEnum: SourceEnum.WatchMovies,
                        ),
                      ),
                    ],
                  ),
                  )
                        ],
                      )) : Container(),
                )
              ],
            ));
  }

  SizedBox _buildErrorWidget(String error, lottieanimation) {
    return SizedBox(
      height: 70.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(title: error),
          SizedBox(
            height: 2.h,
          ),
          LottieBuilder.asset(
            lottieanimation,
            height: 50.h,
          ),
        ],
      ),
    );
  }
}
