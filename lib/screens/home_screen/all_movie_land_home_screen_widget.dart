import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/all_movie_land_home_category_enum.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/enums/up_movies_home_category_enum.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AllMovieLandHomeScreenWidget extends StatefulWidget {
  const AllMovieLandHomeScreenWidget({super.key});

  @override
  State<AllMovieLandHomeScreenWidget> createState() => _AllMovieLandHomeScreenWidgetState();
}

class _AllMovieLandHomeScreenWidgetState extends State<AllMovieLandHomeScreenWidget> {

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=> homeScreenController.isAllMovieLandHomePageLoading.value ? RefreshIndicator(
      onRefresh: () async {
        homeScreenController.isAllMovieLandHomePageLoading.value = false;
        homeScreenController.loadAllMovieLandHomeScreen();
      },
      child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CarouselWidget(
                        sourceEnum: SourceEnum.AllMovieLand,
                        list: homeScreenController.allMovieLandCategoryListMap![AllMovieLandHomeCategoryEnum.Featured.name]!,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                title: 'Bollywood',
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.allMovieLandCategoryListMap![AllMovieLandHomeCategoryEnum.Bollywood.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.AllMovieLand,
                                isHomeScreen: true,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const CustomText(
                                title: "Hollywood",
                                size: 12,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MovieListView(
                                controller: ScrollController(),
                                moviesList: homeScreenController.allMovieLandCategoryListMap![AllMovieLandHomeCategoryEnum.Hollywood.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.AllMovieLand,
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
                                moviesList: homeScreenController.allMovieLandCategoryListMap![AllMovieLandHomeCategoryEnum.TvSeries.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.AllMovieLand,
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
                                moviesList: homeScreenController.allMovieLandCategoryListMap![AllMovieLandHomeCategoryEnum.Cartoons.name]!,
                                hasReachedMax: false, sourceEnum: SourceEnum.AllMovieLand,
                                isHomeScreen: true,
                              ),


                            ],
                          ))
                    ],
                  ),
                ),
    ) : Center(child: CircularProgressIndicator(color: AppColors.red),),
    );
  }
}
