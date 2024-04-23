import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/all_movie_land_detail_controller.dart';
import 'package:Movieverse/controllers/hd_movie_2_detail_controller.dart';
import 'package:Movieverse/controllers/search_screen_controller.dart';
import 'package:Movieverse/controllers/primewire_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/enums/media_type_enum.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_detail.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_server_links.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_cover.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_detail.dart';
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/models/primewire/prime_wire_detail.dart';
import 'package:Movieverse/models/primewire/primewire_season_episode.dart';
import 'package:Movieverse/screens/details_screen/all_movie_land/all_movie_land_custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/hdmovie2/hd_movie2_custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/primewire/primewire_custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/widgets/back_button.dart';
import 'package:Movieverse/screens/details_screen/widgets/custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/widgets/search_button.dart';
import 'package:Movieverse/widgets/custom_button.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';


class HdMovie2DetailsScreen extends StatefulWidget {
  HdMovie2Cover hdMovie2Cover;
  HdMovie2DetailsScreen({super.key, required this.hdMovie2Cover});

  @override
  State<HdMovie2DetailsScreen> createState() => _HdMovie2DetailsScreenState();
}

class _HdMovie2DetailsScreenState extends State<HdMovie2DetailsScreen> {

  HdMovie2DetailController hdMovie2DetailController = Get.put(HdMovie2DetailController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return /*BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, moviestate) {
        if (moviestate is MovieDetailsLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.green,
          ));
        } else if (moviestate is MovieDetailsSuccess) {
          return*/ Scaffold(
        body: FutureBuilder<HdMovie2Detail>(
            future:  hdMovie2DetailController.getMovieDetail(widget.hdMovie2Cover!)!,
            builder: (context, snapshot) {

              if(snapshot.hasData)
              {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      leading: const CustomBackButton(),
                      flexibleSpace: HdMovie2CustomFlexibleSpaceBar(hdMovie2Detail: snapshot.data!,),
                      expandedHeight: 65.h,
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(
                            height: 5.h,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  maxLines: 15,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Casts: ',
                                    style:
                                    Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Colors.amber,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data!.actors,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                RichText(
                                  maxLines: 15,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Description : ',
                                    style:
                                    Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Colors.amber,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data!.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                               /* if(allMovieLandDetailController.isSeries)...[
                                  SizedBox(height: 2.h,),
                                  RichText(
                                    maxLines: 15,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'Select Season ',
                                      style:
                                      Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Colors.amber,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h,),
                                  Obx(()=>Center(
                                    child: Container(
                                      width: 80.w,
                                      height: 7.h,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black, // Background color
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: AppColors.red, // Border color
                                          width: 2.0,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        iconEnabledColor: AppColors.red,
                                        value: allMovieLandDetailController.selectedSeason.value,
                                        onChanged: (String? newValue) {
                                          allMovieLandDetailController.selectedEpisode.value = snapshot.data!.seasonEpisodeMap![newValue]![0];
                                          allMovieLandDetailController.selectedSeason.value = newValue!;
                                          allMovieLandDetailController.findSelectedSeasonEpisode();
                                        },
                                        items: snapshot.data!.seasonEpisodeMap!.keys.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text("Season ${value}"),
                                          );
                                        }).toList(),
                                        dropdownColor: Colors.black, // Dropdown background color
                                        underline: SizedBox(), // Remove default underline
                                      ),
                                    ),
                                  ),
                                  ),
                                  SizedBox(height: 2.h),
                                  RichText(
                                    maxLines: 15,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'Select Episode ',
                                      style:
                                      Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Colors.amber,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Obx(()=>Center(
                                    child: Container(
                                      width: 80.w,

                                      height: 7.h,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black, // Background color
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: AppColors.red, // Border color
                                          width: 2.0,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: allMovieLandDetailController.selectedEpisode.value,
                                        iconEnabledColor: AppColors.red,
                                        isExpanded: true,
                                        onChanged: ( newValue) {
                                          allMovieLandDetailController.selectedEpisode.value = newValue!;
                                          allMovieLandDetailController.findSelectedSeasonEpisode();
                                        },
                                        items:snapshot.data!.seasonEpisodeMap![allMovieLandDetailController.selectedSeason.value]?.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text("Episode ${value}"),
                                          );
                                        }).toList(),
                                        dropdownColor: Colors.black, // Dropdown background color
                                        underline: SizedBox(), // Remove default underline
                                      ),
                                    ),
                                  ),
                                  ),
                                ],*/
                                SizedBox(height: 2.h),
                                Center(
                                  child: CustomButton(func: () async{
                                    LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Fetching Server Links.....");
                                    (String,Map<String,Map<String,String>>) map = await hdMovie2DetailController.getVideoLinks( snapshot.data!.url!, snapshot.data!.players!);
                                    LoaderDialog.stopLoaderDialog();
                                    ServerListDialog.showServerListDialog(navigatorKey.currentContext!,map.$2,widget.hdMovie2Cover.title!,headers: {"Referer":map.$1},isDirectPlay: true,isNativemxPlayer: true,isDirectProviderLink: true);
                                  }, title: "Play",
                                    color: AppColors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),),
                                ),
                                /*const CustomText(
                            title: 'Cast ',
                            size: 12,
                          ),
                         // const CastWidget(),
                          const CustomText(
                            title: 'Screenshots ',
                            size: 12,
                          ),*/
                                //const ScreenshotWidget(),
                                SizedBox(height: 2.h),
                                SizedBox(height: 5.h),
                              ],
                            ),
                          ),
                        ]))
                  ],
                );
              }
              return Center(child: CircularProgressIndicator(),);
            }
        ));
    /*} else if (moviestate is MovieDetailsError) {
          return CustomErrorWidget(
            error: moviestate.error,
            func: () {
              context.read<MovieDetailsBloc>().add(LoadMovieDetails(widget.id));
              context.read<MovieImagesBloc>().add(LoadMovieImages(widget.id));
              context.read<MovieCastBloc>().add(LoadMovieCast(widget.id));
              context.read<MovieVideoBloc>().add(LoadMovieVideo(widget.id));
            },
          );
        }

        return const SizedBox.shrink();
      },
    );*/
  }
}
