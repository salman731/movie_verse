import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_detail.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_detail.dart';
import 'package:Movieverse/models/primewire/prime_wire_detail.dart';
import 'package:Movieverse/models/up_movies/up_movie_detail.dart';
import 'package:Movieverse/screens/details_screen/widgets/build_column_info.dart';
import 'package:Movieverse/screens/details_screen/widgets/favorite_button.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class PrMoviesCustomFlexibleSpaceBar extends StatefulWidget {
  PrMoviesDetail prMoviesDetail;
  PrMoviesCustomFlexibleSpaceBar({super.key,required this.prMoviesDetail});
  @override
  PrMoviesCustomFlexibleSpaceBarState createState() {
    return PrMoviesCustomFlexibleSpaceBarState();
  }
}

class PrMoviesCustomFlexibleSpaceBarState extends State<PrMoviesCustomFlexibleSpaceBar> {
  ScrollPosition? _position;
  bool? _visible;


  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
    context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      expandedTitleScale: 1,
      background: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl:
            widget.prMoviesDetail.imageURL!,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                )),
          ),
          SizedBox(height: 2.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                title: widget.prMoviesDetail.title!,
                maxlines: 4,
                horizontalpadding: 20,
              ),
              SizedBox(height: 2.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.prMoviesDetail.genre!.split(" ").length,
                        (index) => CustomText(
                      title:  widget.prMoviesDetail.genre!.split(" ")[index] + " ",
                      color: Colors.grey,
                      size: 8,
                    ),
                  )),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: List.generate(
                        double.parse(widget.prMoviesDetail.ratings!).toInt(),
                            (index) => Icon(
                          index == double.parse(widget.prMoviesDetail.ratings!).toInt()
                              ? Icons.star_half
                              : Icons.star,
                          color: Colors.amber,
                          size: 15.sp,
                        )),
                  ),
                  SizedBox(width: 1.w),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CustomText(
                      title: widget.prMoviesDetail.ratings!,
                      size: 8,
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildColumnInfo(
                    title: 'Language/Quality',
                    content: widget.prMoviesDetail.languageQuality!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.languageQuality! ,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Runtime',
                    content:
                    widget.prMoviesDetail.runtime!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.runtime!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Released',
                    content:
                    widget.prMoviesDetail.released!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.released!,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(widget.prMoviesDetail.studio!.isNotEmpty)...[
                    BuildColumnInfo(
                      title: 'Studio',
                      content: widget.prMoviesDetail.studio!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.studio! ,
                    ),
                  ],
                  if(widget.prMoviesDetail.tvStatus!.isNotEmpty)...[
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Tv Status',
                    content:
                    widget.prMoviesDetail.tvStatus!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.tvStatus!,
                  ),
                  ],
                  if(widget.prMoviesDetail.networks!.isNotEmpty)...[
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Networks',
                    content:
                    widget.prMoviesDetail.networks!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.networks!,
                  ),
                   ]
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildColumnInfo(
                    title: 'Country',
                    content:widget.prMoviesDetail.country!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.country!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Director',
                    content:
                    widget.prMoviesDetail.director!.trim().isEmpty ? "N/A" : widget.prMoviesDetail.director!,
                  ),
                ],
              ),
              /*SizedBox(height: 2.h),
              *//*BlocBuilder<MovieVideoBloc, MovieVideoState>(
                builder: (context, state) {
                  if (state is MovieVideoSuccess) {
                    return *//*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: CustomButton(
                            func: () {
                            },
                            title: 'Play Trailer',
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomFavoriteButton(
                          func: () {
                     *//*       User? user =
                                Supabase.instance.client.auth.currentUser;
                            FavoriteMocvie movie = FavoriteMocvie(
                              movieID: widget.movie.id,
                              posterPath: widget.movie.posterPath,
                              title: widget.movie.title,
                              overview: widget.movie.overview,
                              userID: user!.id,
                            );
                            if (user.email != 'omar@gmail.com') {
                              DataBaseService()
                                  .addMovie(mocvie: movie)
                                  .then((value) {
                                context.showsnackbar(
                                    title: 'Movie Saved Successfully',
                                    color: AppColors.green);
                              }).catchError((e) {
                                context.showsnackbar(
                                    title: e.toString(), color: Colors.red);
                              });
                            } else {
                              context.showsnackbar(
                                  title:
                                      "Sorry, but you can't save movies as an anonymous user !\n--> Please Log In with your email so you can save movies.",
                                  color: Colors.red);
                            }*//*
                          },
                        )
                      ],
                    )*/
              /*    }
                  return const SizedBox.shrink();
                },
              )*/
            ],
          )
        ],
      ),
      title: Visibility(
        visible: (_visible ?? false),
        child: const CustomText(
          title: 'Movieverse',
          color: AppColors.red,
        ),
      ),
    );
  }
  
}
