
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/models/primewire/prime_wire_detail.dart';
import 'package:Movieverse/screens/details_screen/all_movie_land/all_movie_land_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/primewire/primewire_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/up_movies/up_movies_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'carousel_item.dart';

class CarouselWidget extends StatelessWidget {
  SourceEnum sourceEnum;
  List<dynamic> list;
   CarouselWidget({
    Key? key,
    required this.list,
    required this.sourceEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: list
            .sublist(0, list.length)
            .map(
              (item) => CarouselItem(
                  avatar: item.imageURL!,
                  title: item.title!.contains("+") ? item.title!.split("+")[0].replaceAll("\n", "").replaceAll("\t", "").trim() : item.title,
                  additionalInfo: item.title!.contains("+") ? item.title!.split("+")[1].replaceAll("\n", "").replaceAll("\t", "").trim() : "",
                  onTapList: () {

                  },
                  onTap: (){
                    switch (sourceEnum)
                    {
                      case SourceEnum.UpMovies:
                        item.title = item.title!.split("+")[0].replaceAll("\n", "").replaceAll("\t", "").trim();
                        Get.to(UpMoviesDetailScreen(upMoviesCover: item));
                      case SourceEnum.Primewire:
                        item.title = item.title!.split("+")[0].replaceAll("\n", "").replaceAll("\t", "").trim();
                        Get.to(PrimewireDetailsScreen(primeWireCover: item));
                      case SourceEnum.Film1k:
                        /*Get.to(Film1kDetailScreen(film1kCover: moviesList[index]));*/
                      case SourceEnum.AllMovieLand:
                        Get.to(AllMovieLandDetailsScreen(allMovieLandCover: item));

                      case SourceEnum.PrMovies:
                        // TODO: Handle this case.
                    }
                  }),
            )
            .toList(),
        options: CarouselOptions(
          aspectRatio: 2 / 1.9,
          autoPlay: true,
          viewportFraction: 1,
          autoPlayAnimationDuration: const Duration(seconds: 2),
          enlargeCenterPage: false,
        ));
  }
}
