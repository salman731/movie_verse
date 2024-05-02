import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/all_movie_land_home_category_enum.dart';
import 'package:Movieverse/enums/pr_movies_home_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/enums/watch_series_home_screen_category_enum.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/watch_series/watch_series_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WatchSeriesHomeScreenWidget extends StatefulWidget {
  const WatchSeriesHomeScreenWidget({super.key});

  @override
  State<WatchSeriesHomeScreenWidget> createState() => _WatchSeriesHomeScreenWidgetState();
}

class _WatchSeriesHomeScreenWidgetState extends State<WatchSeriesHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return  Obx(()=> homeScreenController.isWatchSeriesHomePageLoading.value ? RefreshIndicator(
      onRefresh: () async {
        homeScreenController.isWatchSeriesHomePageLoading.value = false;
        homeScreenController.loadWatchSeriesHomeScreen();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            CarouselWidget(
              sourceEnum: SourceEnum.WatchSeries,
              isTagAvailable: true,
              list: homeScreenController.watchSeriesCategoryListMap![WatchSeriesHomeScreenCategoryEnum.Top.name]!,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    for(MapEntry<String,List<WatchSeriesCover>> mapEntry in homeScreenController.watchSeriesCategoryListMap!.entries)...
                    [
                      if(mapEntry.key != WatchSeriesHomeScreenCategoryEnum.Top.name)...
                      [
                        CustomText(
                          title: mapEntry.key.replaceAll("_", " "),
                          size: 12,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        MovieListView(
                          controller: ScrollController(),
                          moviesList: mapEntry.value!,
                          hasReachedMax: false, sourceEnum: SourceEnum.WatchSeries,
                          isHomeScreen: true,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ]
                    ],


                  ],
                ))
          ],
        ),
      ),
    ): Center(child: CircularProgressIndicator(color: AppColors.red),),
    );
  }
}
