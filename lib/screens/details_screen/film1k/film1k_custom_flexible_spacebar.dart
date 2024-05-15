import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/models/film_1k/film_1k_detail.dart';
import 'package:Movieverse/screens/details_screen/widgets/build_column_info.dart';
import 'package:Movieverse/screens/details_screen/widgets/favorite_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class Film1kCustomFlexibleSpaceBar extends StatefulWidget {
   Film1kDetail film1kDetail;
   Film1kCustomFlexibleSpaceBar({super.key,required this.film1kDetail});
  @override
  Film1kCustomFlexibleSpaceBarState createState() {
    return Film1kCustomFlexibleSpaceBarState();
  }
}

class Film1kCustomFlexibleSpaceBarState extends State<Film1kCustomFlexibleSpaceBar> {
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
                widget.film1kDetail!.imageURL!,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                title: widget.film1kDetail.title!,
                maxlines: 4,
                horizontalpadding: 20,
              ),
              SizedBox(height: 2.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.film1kDetail.genre!.split(",").length,
                    (index) => CustomText(
                      title: widget.film1kDetail.genre!.split(",")[index],
                      color: Colors.grey,
                      size: 8,
                    ),
                  )),
              /*SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: List.generate(
                        widget.movie.voteAverage.toInt() + 1,
                        (index) => Icon(
                              index == widget.movie.voteAverage.toInt()
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
                      title: widget.movie.voteAverage.toStringAsFixed(1),
                      size: 8,
                    ),
                  )
                ],
              ),*/
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildColumnInfo(
                    title: 'Released Date',
                    content: widget.film1kDetail.released!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'RunTime',
                    content:
                        widget.film1kDetail.runtime!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Director',
                    content: widget.film1kDetail.director!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Language',
                    content: widget.film1kDetail.language!,
                  ),
                ],
              ),
              SizedBox(height: 2.h),

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
