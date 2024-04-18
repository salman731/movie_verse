import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/all_movie_land_home_category_enum.dart';
import 'package:Movieverse/enums/pr_movies_home_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Film1kHomeScreenWidget extends StatefulWidget {
  const Film1kHomeScreenWidget({super.key});

  @override
  State<Film1kHomeScreenWidget> createState() => _Film1kHomeScreenWidgetState();
}

class _Film1kHomeScreenWidgetState extends State<Film1kHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,List<Film1kCover>>>(future: homeScreenController.loadFilm1kHomeScreen(),

        builder: (context,snapshot) {
          if(snapshot.hasData)
          {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CarouselWidget(
                    sourceEnum: SourceEnum.Film1k,
                    list: snapshot.data!["Featured"]!,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          for(MapEntry<String,List<Film1kCover>> mapEntry in snapshot.data!.entries)...
                          [
                             if(mapEntry.key != "Featured")...
                                 [
                                   CustomText(
                                     title: mapEntry.key,
                                     size: 12,
                                   ),
                                   SizedBox(
                                     height: 2.h,
                                   ),
                                   MovieListView(
                                     controller: ScrollController(),
                                     moviesList: mapEntry.value!,
                                     hasReachedMax: false, sourceEnum: SourceEnum.Film1k,
                                     isHomeScreen: true,
                                   ),
                                   SizedBox(
                                     height: 2.h,
                                   ),
                                 ]
                          ],
                          /*const CustomText(
                            title: 'Bollywood Movies',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          MovieListView(
                            controller: ScrollController(),
                            moviesList: snapshot.data![PrMoviesHomeScreenCategoryEnum.Bollywood.name]!,
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
                            moviesList: snapshot.data![AllMovieLandHomeCategoryEnum.Hollywood.name]!,
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
                            moviesList: snapshot.data![PrMoviesHomeScreenCategoryEnum.HotSeries.name]!,
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
                            moviesList: snapshot.data![PrMoviesHomeScreenCategoryEnum.Cinema.name]!,
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
                            moviesList: snapshot.data![PrMoviesHomeScreenCategoryEnum.DualAudioMovies.name]!,
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
                            moviesList: snapshot.data![PrMoviesHomeScreenCategoryEnum.EnglishSeries.name]!,
                            hasReachedMax: false, sourceEnum: SourceEnum.PrMovies,
                            isHomeScreen: true,
                          ),*/

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
