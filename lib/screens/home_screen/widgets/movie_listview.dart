import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/main_screen_controller.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/models/up_movies_cover.dart';
import 'package:Movieverse/screens/details_screen/primewire/primewire_detail_screen_2.dart';
import 'package:Movieverse/screens/details_screen/up_movies/up_movies_detail_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'movie_card.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({
    Key? key,
    required this.controller,
    required this.hasReachedMax,
    required this.sourceEnum,
    required this.moviesList,
    required
  }) : super(key: key);

  final ScrollController controller;
  final bool hasReachedMax;
  final SourceEnum sourceEnum;
  final List<dynamic> moviesList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      width: 100.w,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: !hasReachedMax ? moviesList.length : moviesList.length + 1,
        itemBuilder: (context, index) {
          if (index < moviesList.length) {
            return InkWell(
              onTap: (){
                switch (sourceEnum)
                {
                  case SourceEnum.UpMovies:
                    Get.to(UpMoviesDetailScreen2(upMoviesCover: Get.find<SearchScreenController>().upMoviesSearchList[index]));
                  case SourceEnum.Primewire:
                    Get.find<SearchScreenController>().primewireMovieTitle = Get.find<SearchScreenController>().primeWireSearchList[index].title;
                    Get.to(PrimewireDetailsScreen2(primeWireCover: Get.find<SearchScreenController>().primeWireSearchList[index]));
                  case SourceEnum.Film1k:
                  case SourceEnum.AllMovieLand:
                }
              },
              child: MovieCard(
                imgurl: moviesList[index].imageURL!,
                title: moviesList[index].title!,
                rate: 2.4,
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.red),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
