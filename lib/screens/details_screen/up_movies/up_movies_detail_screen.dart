import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/up_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/up_movies/up_movie_detail.dart';
import 'package:Movieverse/models/up_movies/up_movies_cover.dart';
import 'package:Movieverse/screens/details_screen/up_movies/up_movies_custom_flexible_spacebar.dart';
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



class UpMoviesDetailScreen extends StatefulWidget {
  UpMoviesCover upMoviesCover;
  UpMoviesDetailScreen({super.key, required this.upMoviesCover});

  @override
  State<UpMoviesDetailScreen> createState() => _UpMoviesDetailScreenState();
}

class _UpMoviesDetailScreenState extends State<UpMoviesDetailScreen> {

  UpMovieDetailController movieDetailController = Get.put(UpMovieDetailController());
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
        body: FutureBuilder<UpMovieDetail>(
          future: movieDetailController.getMovieDetail(widget.upMoviesCover!)!,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                pinned: true,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                leading: const CustomBackButton(),
                                flexibleSpace: UpMoviesCustomFlexibleSpaceBar(upMovieDetail: snapshot.data!,),
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
                                        if(movieDetailController.checkifEpisodeExist)...[
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
                                                child: DropdownButton<int>(
                                                  isExpanded: true,
                                                  iconEnabledColor: AppColors.red,
                                                  value: movieDetailController.selectedEpisode.value,
                                                  onChanged: (int? newValue) {
                                                    movieDetailController.selectedEpisode.value = newValue!;
                                                  },
                                                  items: movieDetailController.episodeMap.keys.map((int value) {
                                                    return DropdownMenuItem<int>(
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
                                              if(!movieDetailController.checkifEpisodeExist)
                                              {
                                                ServerListDialog.showServerListDialog(navigatorKey.currentContext!, await movieDetailController.getServerPages(),widget.upMoviesCover.title!);
                                              }
                                              else
                                              {
                                                ServerListDialog.showServerListDialog(navigatorKey.currentContext!, await movieDetailController.getServerPages(episodePageUrl: movieDetailController.episodeMap[movieDetailController.selectedEpisode],isSeries: true),widget.upMoviesCover.title!);
                                              }
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
