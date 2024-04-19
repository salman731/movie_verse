import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/pr_movies_detail_controller.dart';
import 'package:Movieverse/controllers/search_screen_controller.dart';
import 'package:Movieverse/controllers/primewire_movie_detail_controller.dart';
import 'package:Movieverse/controllers/watch_movies_detail_controller.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/enums/media_type_enum.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_detail.dart';
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/models/primewire/prime_wire_detail.dart';
import 'package:Movieverse/models/primewire/primewire_season_episode.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_detail.dart';
import 'package:Movieverse/screens/details_screen/pr_movies/pr_movies_custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/primewire/primewire_custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/watch_movies/watch_movies_custom_flexible_spacebar.dart';
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


class WatchMoviesDetailScreen extends StatefulWidget {
  WatchMoviesCover watchMoviesCover;
  WatchMoviesDetailScreen({super.key, required this.watchMoviesCover,});

  @override
  State<WatchMoviesDetailScreen> createState() => _WatchMoviesDetailScreenState();
}

class _WatchMoviesDetailScreenState extends State<WatchMoviesDetailScreen> {

  WatchMoviesDetailController watchMoviesDetailController = Get.put(WatchMoviesDetailController());
  SearchScreenController searchScreenController = Get.put(SearchScreenController());
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
        body: FutureBuilder<WatchMoviesDetail>(
            future:  watchMoviesDetailController.getMoviesDetail(widget.watchMoviesCover!)!,
            builder: (context, snapshot) {

              if(snapshot.hasData)
              {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      leading: const CustomBackButton(),
                      flexibleSpace: WatchMoviesCustomFlexibleSpaceBar(watchMoviesDetail: snapshot.data!,),
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
                                    text: 'Views : ',
                                    style:
                                    Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Colors.amber,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data!.views,
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
                                RichText(
                                  maxLines: 15,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Gernes : ',
                                    style:
                                    Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Colors.amber,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data!.genre,
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

                                /*if(PrMoviesDetailController.isSeries)...[
                                  SizedBox(height: 2.h,),
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
                                        value: prMoviesDetailController.selectedEpisode.value,
                                        onChanged: (String? newValue) {
                                          prMoviesDetailController.selectedEpisode.value = newValue!;
                                        },
                                        items: snapshot.data!.episodeMap!.keys.map((String value) {
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
                                ],*/
                                SizedBox(height: 2.h),
                                Center(
                                  child: CustomButton(func: () async {
                                    LoaderDialog.showLoaderDialog(navigator!.context,text: "Fetching Video Links ......");
                                    Map<String,Map<String,String>> map;
                                    map =  watchMoviesDetailController.getServerPages();
                                    LoaderDialog.stopLoaderDialog();
                                    ServerListDialog.showServerListDialog(navigator!.context, map, widget.watchMoviesCover.title!,isDirectProviderLink: true,headers: {"Referer":"https://www.watch-movies.com.pk/"},videotoIframeAllowed: true);
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
