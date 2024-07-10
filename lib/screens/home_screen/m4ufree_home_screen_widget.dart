import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/cinezone_home_category_enum.dart';
import 'package:Movieverse/enums/m4ufree_home_category_emum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/watch_series_home_screen_category_enum.dart';
import 'package:Movieverse/models/cinezone/cinezone_cover.dart';
import 'package:Movieverse/models/m4u_free/m4ufree_cover.dart';
import 'package:Movieverse/models/watch_series/watch_series_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class M4UFreeHomeScreenWidget extends StatefulWidget {
  const M4UFreeHomeScreenWidget({super.key});

  @override
  State<M4UFreeHomeScreenWidget> createState() => _M4UFreeHomeScreenWidgetState();
}

class _M4UFreeHomeScreenWidgetState extends State<M4UFreeHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return  Obx(()=> homeScreenController.isM4UFreePageLoading.value ? RefreshIndicator(
      onRefresh: () async {
        homeScreenController.isM4UFreePageLoading.value = false;
        homeScreenController.loadM4UFreeHomeScreen();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            CarouselWidget(
              sourceEnum: SourceEnum.M4UFree,
              isTagAvailable: true,
              list: homeScreenController.mp4ufreeCategoryListMap![M4UFreeHomeCategoryEnum.Featured.name]!,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    for(MapEntry<String,List<M4UFreeCover>> mapEntry in homeScreenController.mp4ufreeCategoryListMap!.entries)...
                    [
                      if(mapEntry.key != M4UFreeHomeCategoryEnum.Featured.name)...
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
                          hasReachedMax: false, sourceEnum: SourceEnum.M4UFree,
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
