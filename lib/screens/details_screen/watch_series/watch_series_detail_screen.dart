import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/watch_series_detail_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/watch_series/watch_series_cover.dart';
import 'package:Movieverse/models/watch_series/watch_series_detail.dart';
import 'package:Movieverse/screens/details_screen/watch_series/watch_series_custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/widgets/back_button.dart';
import 'package:Movieverse/widgets/custom_button.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';



class WatchSeriesDetailScreen extends StatefulWidget {
  WatchSeriesCover watchSeriesCover;
  WatchSeriesDetailScreen({super.key, required this.watchSeriesCover});

  @override
  State<WatchSeriesDetailScreen> createState() => _WatchSeriesDetailScreenState();
}

class _WatchSeriesDetailScreenState extends State<WatchSeriesDetailScreen> {

  WatchSeriesDetailController watchSeriesDetailController = Get.put(WatchSeriesDetailController());
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
        body: FutureBuilder<WatchSeriesDetail>(
            future: watchSeriesDetailController.getMovieDetail(widget.watchSeriesCover!)!,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      leading: const CustomBackButton(),
                      flexibleSpace: WatchSeriesCustomFlexibleSpaceBar(watchSeriesDetail: snapshot.data!,),
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
                                SizedBox(height: 2.h,),
                                RichText(
                                  maxLines: 15,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Casts : ',
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
                                SizedBox(height: 2.h,),
                                RichText(
                                  maxLines: 15,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Production : ',
                                    style:
                                    Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Colors.amber,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data!.production,
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
                                SizedBox(height: 2.h,),
                                if(snapshot.data!.url!.contains("/tv/") && snapshot.data!.episodeSeasonMap!.isNotEmpty)...[
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
                                        isExpanded: true,
                                        iconEnabledColor: AppColors.red,
                                        value: watchSeriesDetailController.selectedSeason.value,
                                        onChanged: (String? newValue) {
                                          watchSeriesDetailController.selectedSeason.value = newValue!;
                                          watchSeriesDetailController.selectedEpisode.value = snapshot.data!.episodeSeasonMap![newValue]!.keys.first;
                                        },
                                        items: snapshot!.data!.episodeSeasonMap!.keys.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text("${value}"),
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
                                        isExpanded: true,
                                        iconEnabledColor: AppColors.red,
                                        value: watchSeriesDetailController.selectedEpisode.value,
                                        onChanged: (String? newValue) {
                                          watchSeriesDetailController.selectedEpisode.value = newValue!;
                                        },
                                        items: snapshot.data!.episodeSeasonMap![watchSeriesDetailController.selectedSeason.value]!.keys.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text("${value}"),
                                          );
                                        }).toList(),
                                        dropdownColor: Colors.black, // Dropdown background color
                                        underline: SizedBox(), // Remove default underline
                                      ),
                                    ),
                                  ),
                                  ),
                                ],
                                SizedBox(height: 2.h),
                                Center(
                                  child: CustomButton(func: () async {
                                    LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Fetching Server Links......");
                                    String mediaId = "";
                                    late bool isTvshow;
                                    if(snapshot.data!.url!.contains("/tv/"))
                                      {
                                          isTvshow = true;
                                         mediaId = snapshot.data!.episodeSeasonMap![watchSeriesDetailController.selectedSeason.value]![watchSeriesDetailController.selectedEpisode.value]!;
                                      }
                                    else
                                      {
                                        isTvshow = false;
                                        mediaId = snapshot.data!.id!;
                                      }
                                    Map<String,Map<String,String>> map = await  watchSeriesDetailController.getVideoServerLinks(mediaId,isTvShow: isTvshow);
                                    LoaderDialog.stopLoaderDialog();
                                    ServerListDialog.showServerListDialog(navigatorKey.currentContext!, map,widget.watchSeriesCover.title!,isDirectPlay: true,isNativemxPlayer: false);


                                  }, title: "Play",
                                    color: AppColors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),),
                                ),
                               /* const CustomText(
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
