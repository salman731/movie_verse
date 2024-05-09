import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/cinezone_home_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/watch_series_home_screen_category_enum.dart';
import 'package:Movieverse/models/cinezone/cinezone_cover.dart';
import 'package:Movieverse/models/watch_series/watch_series_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CineZoneHomeScreenWidget extends StatefulWidget {
  const CineZoneHomeScreenWidget({super.key});

  @override
  State<CineZoneHomeScreenWidget> createState() => _CineZoneHomeScreenWidgetState();
}

class _CineZoneHomeScreenWidgetState extends State<CineZoneHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return  Obx(()=> homeScreenController.isCineZoneHomePageLoading.value ? RefreshIndicator(
      onRefresh: () async {
        homeScreenController.isCineZoneHomePageLoading.value = false;
        homeScreenController.loadCineZoneHomeScreen();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            CarouselWidget(
              sourceEnum: SourceEnum.CineZone,
              isTagAvailable: true,
              list: homeScreenController.cineZoneCategoryListMap![CineZoneHomeCategoryEnum.Featured.name]!,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    for(MapEntry<String,List<CineZoneCover>> mapEntry in homeScreenController.cineZoneCategoryListMap!.entries)...
                    [
                      if(mapEntry.key != CineZoneHomeCategoryEnum.Featured.name)...
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
                          hasReachedMax: false, sourceEnum: SourceEnum.CineZone,
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
