import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/models/prime_wire_detail.dart';
import 'package:Movieverse/models/up_movie_detail.dart';
import 'package:Movieverse/screens/details_screen/widgets/favorite_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class PrimewireCustomFlexibleSpaceBar extends StatefulWidget {
  PrimeWireDetail primeWireDetail;
  PrimewireCustomFlexibleSpaceBar({super.key,required this.primeWireDetail});
  @override
  PrimewireCustomFlexibleSpaceBarState createState() {
    return PrimewireCustomFlexibleSpaceBarState();
  }
}

class PrimewireCustomFlexibleSpaceBarState extends State<PrimewireCustomFlexibleSpaceBar> {
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
            widget.primeWireDetail.imageURL!,
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
                title: widget.primeWireDetail.title!,
                maxlines: 4,
                horizontalpadding: 20,
              ),
              SizedBox(height: 2.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.primeWireDetail.genre!.split(" ").length,
                        (index) => CustomText(
                      title: widget.primeWireDetail.genre!.split(" ")[index] + " ",
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
                        double.parse(widget.primeWireDetail.ratings!.split("/")[0]).toInt()+ 1,
                            (index) => Icon(
                          index == double.parse(widget.primeWireDetail.ratings!.split("/")[0]).toInt()
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
                      title: widget.primeWireDetail.ratings!.split("/")[0],
                      size: 8,
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCoulmnInfo(
                    title: 'Released Date',
                    content: widget.primeWireDetail.releasedDate!,
                  ),
                  SizedBox(width: 4.w),
                  _buildCoulmnInfo(
                    title: 'Duration',
                    content:
                    widget.primeWireDetail.duration!,
                  ),
                  SizedBox(width: 4.w),
                  _buildCoulmnInfo(
                    title: 'Country',
                    content: widget.primeWireDetail.country!,
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

  Column _buildCoulmnInfo({required String title, required String content}) {
    return Column(
      children: [
        CustomText(
          title: title,
          color: Colors.grey,
          size: 8,
        ),
        SizedBox(
          height: 1.h,
        ),
        CustomText(
          title: content,
          size: 10,
        ),
      ],
    );
  }
}
