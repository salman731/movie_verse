import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/hd_movie_2_home_screen_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HdMovie2HomeScreenWidget extends StatefulWidget {
  const HdMovie2HomeScreenWidget({super.key});

  @override
  State<HdMovie2HomeScreenWidget> createState() => _HdMovie2HomeScreenWidgetState();
}

class _HdMovie2HomeScreenWidgetState extends State<HdMovie2HomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return  Obx(()=> homeScreenController.isHdMovie2HomePageLoading.value ? SingleChildScrollView(
      child: Column(
        children: [
          CarouselWidget(
            sourceEnum: SourceEnum.HdMovie2,
            list: homeScreenController.hdMovie2CategoryListMap![HdMovie2HomeScreenCategoryEnum.Featured_Movies.name]!,
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  for(MapEntry<String,List<HdMovie2Cover>> mapEntry in homeScreenController.hdMovie2CategoryListMap!.entries)...
                  [
                    if(mapEntry.key != HdMovie2HomeScreenCategoryEnum.Featured_Movies.name)...
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
                        hasReachedMax: false, sourceEnum: SourceEnum.HdMovie2,
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
    ): Center(child: CircularProgressIndicator(color: AppColors.red),),
    );
  }
}
