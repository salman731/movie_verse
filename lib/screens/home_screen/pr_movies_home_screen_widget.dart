import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/all_movie_land_home_category_enum.dart';
import 'package:Movieverse/enums/pr_movies_home_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PrMoviesHomeScreenWidget extends StatefulWidget {
  const PrMoviesHomeScreenWidget({super.key});

  @override
  State<PrMoviesHomeScreenWidget> createState() => _PrMoviesHomeScreenWidgetState();
}

class _PrMoviesHomeScreenWidgetState extends State<PrMoviesHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=> homeScreenController.isPrMoviesHomePageLoading.value ? RefreshIndicator(
      onRefresh: () async{
        homeScreenController.isPrMoviesHomePageLoading.value = false;
        homeScreenController.loadPrMoviesHomeScreen();
      },
      child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CarouselWidget(
                        sourceEnum: SourceEnum.PrMovies,
                        list: homeScreenController.prMoviesCategoryListMap![PrMoviesHomeScreenCategoryEnum.Featured.name]!,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                title: 'Bollywood Movies',
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.prMoviesCategoryListMap![PrMoviesHomeScreenCategoryEnum.Bollywood.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.PrMovies,
                                isHomeScreen: true,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const CustomText(
                                title: "Hollywood Movies",
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.prMoviesCategoryListMap![AllMovieLandHomeCategoryEnum.Hollywood.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.PrMovies,
                                isHomeScreen: true,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const CustomText(
                                title: 'Hot Series',
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.prMoviesCategoryListMap![PrMoviesHomeScreenCategoryEnum.HotSeries.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.PrMovies,
                                isHomeScreen: true,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const CustomText(
                                title: 'Cinema Movies',
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.prMoviesCategoryListMap![PrMoviesHomeScreenCategoryEnum.Cinema.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.PrMovies,
                                isHomeScreen: true,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const CustomText(
                                title: 'Dual Audio Movies',
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.prMoviesCategoryListMap![PrMoviesHomeScreenCategoryEnum.DualAudioMovies.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.PrMovies,
                                isHomeScreen: true,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const CustomText(
                                title: 'English Series',
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.prMoviesCategoryListMap![PrMoviesHomeScreenCategoryEnum.EnglishSeries.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.PrMovies,
                                isHomeScreen: true,
                              ),

                            ],
                          ))
                    ],
                  ),
                ),
    ) : Center(child: CircularProgressIndicator(color: AppColors.red),),
    );

  }
}
