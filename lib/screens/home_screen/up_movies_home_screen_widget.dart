import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/models/up_movies/up_movies_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class UpMoviesHomeScreenWidget extends StatefulWidget {
  const UpMoviesHomeScreenWidget({super.key});

  @override
  State<UpMoviesHomeScreenWidget> createState() => _UpMoviesHomeScreenWidgetState();
}

class _UpMoviesHomeScreenWidgetState extends State<UpMoviesHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,List<UpMoviesCover>>>(future: homeScreenController.loadUpMoviesHomeScreen(),

        builder: (context,snapshot) {
      if(snapshot.hasData)
        {
          return SingleChildScrollView(
            child: Column(
              children: [
                CarouselWidget(
                  sourceEnum: SourceEnum.UpMovies,
                  list: snapshot.data![UpMoviesHomeCategoryEnum.TopMovies.name]!,
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
                                  moviesList: snapshot.data![UpMoviesHomeCategoryEnum.LatestMovies.name]!,
                                  hasReachedMax: false, sourceEnum: SourceEnum.UpMovies,
                                  isHomeScreen: true,
                                ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const CustomText(
                          title: 'Tv Series',
                          size: 12,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        MovieListView(
                          controller: ScrollController(),
                          moviesList: snapshot.data![UpMoviesHomeCategoryEnum.TvSeries.name]!,
                          hasReachedMax: false, sourceEnum: SourceEnum.UpMovies,
                          isHomeScreen: true,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const CustomText(
                          title: 'Anime',
                          size: 12,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        MovieListView(
                          controller: ScrollController(),
                          moviesList: snapshot.data![UpMoviesHomeCategoryEnum.Anime.name]!,
                          hasReachedMax: false, sourceEnum: SourceEnum.UpMovies,
                          isHomeScreen: true,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const CustomText(
                          title: 'Cartoons',
                          size: 12,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        MovieListView(
                          controller: ScrollController(),
                          moviesList: snapshot.data![UpMoviesHomeCategoryEnum.Cartoons.name]!,
                          hasReachedMax: false, sourceEnum: SourceEnum.UpMovies,
                          isHomeScreen: true,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const CustomText(
                          title: 'Asian Dramas',
                          size: 12,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        MovieListView(
                          controller: ScrollController(),
                          moviesList: snapshot.data![UpMoviesHomeCategoryEnum.AsianDramas.name]!,
                          hasReachedMax: false, sourceEnum: SourceEnum.UpMovies,
                          isHomeScreen: true,
                        ),


                      ],
                    ))
              ],
            ),
          );
        }
      return Center(child: CircularProgressIndicator(color: AppColors.red),);
    });
  }
}
