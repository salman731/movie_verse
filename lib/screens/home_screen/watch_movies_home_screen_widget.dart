import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/primewire_home_screen_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/enums/watch_movies_home_category_enum.dart';
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WatchMoviesHomeScreenWidget extends StatefulWidget {
  const WatchMoviesHomeScreenWidget({super.key});

  @override
  State<WatchMoviesHomeScreenWidget> createState() => _WatchMoviesHomeScreenWidgetState();
}

class _WatchMoviesHomeScreenWidgetState extends State<WatchMoviesHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return  Obx(()=> homeScreenController.isWatchMoviesHomePageLoading.value ? SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselWidget(
                      sourceEnum: SourceEnum.WatchMovies,
                      list: homeScreenController.watchMoviesCategoryListMap![WatchMoviesHomeScreenCategoryEnum.Featured.name]!,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              title: 'Latest Movies',
                              size: 12,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            MovieListView(
                              controller: ScrollController(),
                              moviesList: homeScreenController.watchMoviesCategoryListMap![WatchMoviesHomeScreenCategoryEnum.Latest.name]!,
                              hasReachedMax: false, sourceEnum: SourceEnum.WatchMovies,
                              isHomeScreen: true,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            const CustomText(
                              title: 'Indian Movies',
                              size: 12,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            MovieListView(
                              controller: ScrollController(),
                              moviesList: homeScreenController.watchMoviesCategoryListMap![WatchMoviesHomeScreenCategoryEnum.Indian.name]!,
                              hasReachedMax: false, sourceEnum: SourceEnum.WatchMovies,
                              isHomeScreen: true,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            const CustomText(
                              title: 'Hindi Dubbed Movies',
                              size: 12,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            MovieListView(
                              controller: ScrollController(),
                              moviesList: homeScreenController.watchMoviesCategoryListMap![WatchMoviesHomeScreenCategoryEnum.HindiDubbed.name]!,
                              hasReachedMax: false, sourceEnum: SourceEnum.WatchMovies,
                              isHomeScreen: true,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            const CustomText(
                              title: 'English Movies',
                              size: 12,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            MovieListView(
                              controller: ScrollController(),
                              moviesList: homeScreenController.watchMoviesCategoryListMap![WatchMoviesHomeScreenCategoryEnum.English.name]!,
                              hasReachedMax: false, sourceEnum: SourceEnum.WatchMovies,
                              isHomeScreen: true,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            const CustomText(
                              title: 'Punjab Movies',
                              size: 12,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            MovieListView(
                              controller: ScrollController(),
                              moviesList: homeScreenController.watchMoviesCategoryListMap![WatchMoviesHomeScreenCategoryEnum.Punjabi.name]!,
                              hasReachedMax: false, sourceEnum: SourceEnum.WatchMovies,
                              isHomeScreen: true,
                            ),


                          ],
                        ))
                  ],
                ),
              ) : Center(child: CircularProgressIndicator(color: AppColors.red),),
    );


  }
}
