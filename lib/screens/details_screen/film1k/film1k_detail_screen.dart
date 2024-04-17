import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/film_1k_detail_controller.dart';
import 'package:Movieverse/controllers/up_movie_detail_controller.dart';
import 'package:Movieverse/dialogs/server_list_dialog.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/film_1k/film_1k_cover.dart';
import 'package:Movieverse/models/film_1k/film_1k_detail.dart';
import 'package:Movieverse/models/up_movies/up_movie_detail.dart';
import 'package:Movieverse/screens/details_screen/film1k/film1k_custom_flexible_spacebar.dart';
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



class Film1kDetailScreen extends StatefulWidget {
  Film1kCover  film1kCover;
  Film1kDetailScreen({super.key, required this.film1kCover});

  @override
  State<Film1kDetailScreen> createState() => _Film1kDetailScreenState();
}

class _Film1kDetailScreenState extends State<Film1kDetailScreen> {

  Film1kController film1kController = Get.put(Film1kController());
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
        body: FutureBuilder<Film1kDetail>(
            future: film1kController.getMovieDetail(widget.film1kCover!)!,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      leading: const CustomBackButton(),
                      flexibleSpace: Film1kCustomFlexibleSpaceBar(film1kDetail: snapshot.data!,),
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
                                SizedBox(height: 2.h),
                                Center(
                                  child: CustomButton(func: () async {
                                    ServerListDialog.showServerListDialog(navigatorKey.currentContext!, await film1kController.getServerPages(),widget.film1kCover.title!,isDirectProviderLink: true,headers: {"Referer":"https://www.film1k.com/"});

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
