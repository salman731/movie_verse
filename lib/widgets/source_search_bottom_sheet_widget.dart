
import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/controllers/search_screen_controller.dart';
import 'package:Movieverse/enums/source_enum.dart';
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
                  // TODO: Handle this case.
                case SourceEnum.AllMovieLand:
                  await searchScreenController.loadAllMovieLand(searchScreenController.homeSearchBarEditingController.text,loadMore: true);
                  selectedSourceList = searchScreenController.allMovieLandSearchList;
                case SourceEnum.PrMovies:
                  await searchScreenController.loadPrMoviesMovies(searchScreenController.homeSearchBarEditingController.text,isLoadMore: true);
                  selectedSourceList = searchScreenController.prMoviesSearchList;
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
        selectedSourceList = searchScreenController.primeWireSearchList;
      case SourceEnum.Film1k:
      // TODO: Handle this case.
      case SourceEnum.AllMovieLand:
        await searchScreenController.loadAllMovieLand(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.allMovieLandSearchList;
      case SourceEnum.PrMovies:
        await searchScreenController.loadPrimeWireMovies(searchScreenController.homeSearchBarEditingController.text);
        selectedSourceList = searchScreenController.prMoviesSearchList;
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

                      },child: MovieCard(imgurl: selectedSourceList[index].imageURL!, title: selectedSourceList[index].title!));
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
