
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/primewire/prime_wire_detail.dart';
import 'package:Movieverse/screens/details_screen/all_movie_land/all_movie_land_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/film1k/film1k_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/hdmovie2/hd_movie2_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/pr_movies/pr_movies_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/primewire/primewire_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/up_movies/up_movies_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/watch_movies/watch_movies_detail_screen.dart';
import 'package:Movieverse/screens/details_screen/watch_series/watch_series_detail_screen.dart';
import 'package:Movieverse/widgets/search_bar_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'carousel_item.dart';

class CarouselWidget extends StatelessWidget {
  SourceEnum sourceEnum;
  List<dynamic> list;
  bool isTagAvailable;
   CarouselWidget({
    Key? key,
    required this.list,
    required this.sourceEnum,
    this.isTagAvailable = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider(
              items: list
                  .sublist(0, list.length)
                  .map(
                    (item) => CarouselItem(
                        avatar: item.imageURL!,
                        title: item.title!.contains("+") ? item.title!.split("+")[0].replaceAll("\n", "").replaceAll("\t", "").trim() : item.title,
                        additionalInfo: !isTagAvailable?item.title!.contains("+") ? item.title!.split("+")[1].replaceAll("\n", "").replaceAll("\t", "").trim() : "" : item.tag1 + " / " + item.tag2,
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
                              Get.to(Film1kDetailScreen(film1kCover: item));
                            case SourceEnum.AllMovieLand:
                              Get.to(AllMovieLandDetailsScreen(allMovieLandCover: item));
                            case SourceEnum.PrMovies:
                              Get.to(PrMoviesDetailScreen(prMoviesCover: item));
                            case SourceEnum.WatchMovies:
                              Get.to(WatchMoviesDetailScreen(watchMoviesCover: item,));
                            case SourceEnum.HdMovie2:
                              Get.to(HdMovie2DetailsScreen(hdMovie2Cover: item));
                            case SourceEnum.WatchSeries:
                              Get.to(WatchSeriesDetailScreen(watchSeriesCover: item));
                            case SourceEnum.CineZone:
                              // TODO: Handle this case.
                            case SourceEnum.Goku:
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
              )),
          Positioned(top: 3.h,child: SizedBox(height: 7.h,width: MediaQuery.of(context).size.width,child: SearchBarTextField())),
        ],
      ),
    );
  }
}
