import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/primewire_home_screen_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PrimewireHomeScreenWidget extends StatefulWidget {
  const PrimewireHomeScreenWidget({super.key});

  @override
  State<PrimewireHomeScreenWidget> createState() => _PrimewireHomeScreenWidgetState();
}

class _PrimewireHomeScreenWidgetState extends State<PrimewireHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,List<PrimeWireCover>>>(future: homeScreenController.loadPrimewireHomeScreen(),

        builder: (context,snapshot) {
          if(snapshot.hasData)
          {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CarouselWidget(
                    sourceEnum: SourceEnum.Primewire,
                    list: snapshot.data![PrimewireHomeScreenCategoryEnum.Featured.name]!,
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
                            moviesList: snapshot.data![PrimewireHomeScreenCategoryEnum.Latest.name]!,
                            hasReachedMax: false, sourceEnum: SourceEnum.Primewire,
                            isHomeScreen: true,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'Trending',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          MovieListView(
                            controller: ScrollController(),
                            moviesList: snapshot.data![PrimewireHomeScreenCategoryEnum.Trending.name]!,
                            hasReachedMax: false, sourceEnum: SourceEnum.Primewire,
                            isHomeScreen: true,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'Recently Added',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          MovieListView(
                            controller: ScrollController(),
                            moviesList: snapshot.data![PrimewireHomeScreenCategoryEnum.Recent.name]!,
                            hasReachedMax: false, sourceEnum: SourceEnum.Primewire,
                            isHomeScreen: true,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'In Theaters',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          MovieListView(
                            controller: ScrollController(),
                            moviesList: snapshot.data![PrimewireHomeScreenCategoryEnum.InTheaters.name]!,
                            hasReachedMax: false, sourceEnum: SourceEnum.Primewire,
                            isHomeScreen: true,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'Streaming',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          MovieListView(
                            controller: ScrollController(),
                            moviesList: snapshot.data![PrimewireHomeScreenCategoryEnum.Streaming.name]!,
                            hasReachedMax: false, sourceEnum: SourceEnum.Primewire,
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
