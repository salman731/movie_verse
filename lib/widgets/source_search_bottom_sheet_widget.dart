
import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/controllers/search_screen_controller.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/screens/details_screen/all_movie_land/all_movie_land_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/cine_zone/cinezone_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/film1k/film1k_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/goku/goku_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/hdmovie2/hd_movie2_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/m4ufree/m4ufree_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/pr_movies/pr_movies_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/primewire/primewire_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/up_movies/up_movies_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/watch_movies/watch_movies_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/watch_series/watch_series_detail_screen.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_card.dart';
import 'package:sliver_fill_remaining_box_adapter/sliver_fill_remaining_box_adapter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SourceSearchBottomSheetWidget extends StatefulWidget {
  const SourceSearchBottomSheetWidget({super.key});

  @override
  State<SourceSearchBottomSheetWidget> createState() => _SourceSearchBottomSheetWidgetState();
}

class _SourceSearchBottomSheetWidgetState extends State<SourceSearchBottomSheetWidget> {

  ScrollController scrollController = ScrollController();
  SearchScreenController searchScreenController = Get.put(SearchScreenController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  RxBool isSourceLoading = false.obs;
  RxBool isMoviesLoading = false.obs;
  List<dynamic> selectedSourceList = [];

  @override
  void initState() {

    getSelectedSourceList();
    scrollController.addListener(() async {
      if (scrollController.position.extentAfter == 0) {
        isMoviesLoading.value = true;
        switch(homeScreenController.selectedSource.value)
            {
                case SourceEnum.UpMovies:
                  await  searchScreenController.loadMoviesfromUpMovies(searchScreenController.homeSearchBarEditingController.text,loadMore: true);
                  selectedSourceList =  searchScreenController.upMoviesSearchList;
                case SourceEnum.Primewire:
                  await searchScreenController.loadPrimeWireMovies(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.primeWireSearchList;
                case SourceEnum.Film1k:
                  await searchScreenController.loadFilm1KMovies(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.film1kSearchList;
                case SourceEnum.AllMovieLand:
                  await searchScreenController.loadAllMovieLand(searchScreenController.homeSearchBarEditingController.text,loadMore: true);
                  selectedSourceList = searchScreenController.allMovieLandSearchList;
                case SourceEnum.PrMovies:
                  await searchScreenController.loadPrMoviesMovies(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.prMoviesSearchList;
                case SourceEnum.WatchMovies:
                  await searchScreenController.loadWatchMoviesSearchList(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.watchMoviesSearchList;
                case SourceEnum.HdMovie2:
                  await searchScreenController.loadHdMovie2SearchList(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.hdMovie2SearchList;
                case SourceEnum.WatchSeries:
                  await searchScreenController.loadWatchSeriesSearchList(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.watchSeriesSearchList;
                case SourceEnum.CineZone:
                  await searchScreenController.loadCineZoneSearchList(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.cineZoneSearchList;
                case SourceEnum.Goku:
                  await searchScreenController.loadGokuSearchList(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.gokuSearchList;
                case SourceEnum.M4UFree:
                  await searchScreenController.loadM4UFreeSearchList(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.m4UFreeSearchList;
            }
        isMoviesLoading.value = false;
      }
    });
  }

  Future<void> getSelectedSourceList () async
  {
    isSourceLoading.value = true;
    switch(homeScreenController.selectedSource.value)
    {
      case SourceEnum.UpMovies:
        await  searchScreenController.loadMoviesfromUpMovies(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList =  searchScreenController.upMoviesSearchList;
      case SourceEnum.Primewire:
        await searchScreenController.loadPrimeWireMovies(searchScreenController.homeSearchBarEditingController.text);
        await searchScreenController.primeWireSearchCompleter.future;
        selectedSourceList = searchScreenController.primeWireSearchList;
      case SourceEnum.Film1k:
        await searchScreenController.loadFilm1KMovies(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.film1kSearchList;
      case SourceEnum.AllMovieLand:
        await searchScreenController.loadAllMovieLand(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.allMovieLandSearchList;
      case SourceEnum.PrMovies:
        await searchScreenController.loadPrMoviesMovies(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.prMoviesSearchList;
      case SourceEnum.WatchMovies:
        await searchScreenController.loadWatchMoviesSearchList(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.watchMoviesSearchList;
      case SourceEnum.HdMovie2:
        await searchScreenController.loadHdMovie2SearchList(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.hdMovie2SearchList;
      case SourceEnum.WatchSeries:
        await searchScreenController.loadWatchSeriesSearchList(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.watchSeriesSearchList;
      case SourceEnum.CineZone:
        await searchScreenController.loadCineZoneSearchList(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.cineZoneSearchList;
      case SourceEnum.Goku:
        await searchScreenController.loadGokuSearchList(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.gokuSearchList;
      case SourceEnum.M4UFree:
        await searchScreenController.loadM4UFreeSearchList(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.m4UFreeSearchList;
    }
    isSourceLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Obx(()=>  !isSourceLoading.value ? CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverGrid(delegate: SliverChildBuilderDelegate((context,index)
                    {
                      return GestureDetector(onTap: (){
                        switch (homeScreenController.selectedSource.value)
                        {
                          case SourceEnum.UpMovies:
                            Get.to(UpMoviesDetailScreen(upMoviesCover: Get.find<SearchScreenController>().upMoviesSearchList[index]));
                          case SourceEnum.Primewire:
                            Get.find<SearchScreenController>().primewireMovieTitle = Get.find<SearchScreenController>().primeWireSearchList[index].title;
                            Get.to(PrimewireDetailsScreen(primeWireCover: Get.find<SearchScreenController>().primeWireSearchList[index]));
                          case SourceEnum.Film1k:
                            Get.to(Film1kDetailScreen(film1kCover: Get.find<SearchScreenController>().film1kSearchList[index]));
                          case SourceEnum.AllMovieLand:
                            Get.to(AllMovieLandDetailsScreen(allMovieLandCover: Get.find<SearchScreenController>().allMovieLandSearchList[index]));
                          case SourceEnum.PrMovies:
                            Get.to(PrMoviesDetailScreen(prMoviesCover: Get.find<SearchScreenController>().prMoviesSearchList[index]));
                          case SourceEnum.WatchMovies:
                            Get.to(WatchMoviesDetailScreen(watchMoviesCover: Get.find<SearchScreenController>().watchMoviesSearchList[index]));

                          case SourceEnum.HdMovie2:
                            Get.to(HdMovie2DetailsScreen(hdMovie2Cover: Get.find<SearchScreenController>().hdMovie2SearchList[index]));
                          case SourceEnum.WatchSeries:
                            Get.to(WatchSeriesDetailScreen(watchSeriesCover: Get.find<SearchScreenController>().watchSeriesSearchList[index]));
                          case SourceEnum.CineZone:
                            Get.to(CineZoneDetailScreen(cineZoneCover: Get.find<SearchScreenController>().cineZoneSearchList[index]));
                          case SourceEnum.Goku:
                            Get.to(GokuDetailScreen(gokuCover: Get.find<SearchScreenController>().gokuSearchList[index]));
                          case SourceEnum.M4UFree:
                            Get.to(M4UFreeDetailScreen(m4uFreeCover: Get.find<SearchScreenController>().m4UFreeSearchList[index]));
                        }
                      },child: MovieCard(imgurl: selectedSourceList[index].imageURL!, title: selectedSourceList[index].title!,tag1: homeScreenController.selectedSource.value == SourceEnum.PrMovies ? selectedSourceList[index].tag! : homeScreenController.selectedSource.value == SourceEnum.HdMovie2 || homeScreenController.selectedSource.value == SourceEnum.WatchSeries ? selectedSourceList[index].tag1 : "" ,tag2: homeScreenController.selectedSource.value == SourceEnum.HdMovie2 || homeScreenController.selectedSource.value == SourceEnum.WatchSeries ? selectedSourceList[index].tag2 : "",));
                    },childCount: selectedSourceList.length), gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisCount: 2,
                    ),),
                    if (isMoviesLoading.value)
                        SliverFillRemainingBoxAdapter(
                          child: Container(
                            color: AppColors.lightblack,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 38,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(color: AppColors.red,),
                            ),
                          ),
                        ),
                  ],
                ) : Center(child: CircularProgressIndicator(color: AppColors.red,),),
      )

    );
  }
}
