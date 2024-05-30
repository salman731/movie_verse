import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/models/film_1k/film_1k_detail.dart';
import 'package:Movieverse/models/m4u_free/m4ufree_detail.dart';
import 'package:Movieverse/screens/details_screen/widgets/build_column_info.dart';
import 'package:Movieverse/screens/details_screen/widgets/favorite_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class M4UFreeCustomFlexibleSpaceBar extends StatefulWidget {
  M4UFreeDetail m4uFreeDetail;
  M4UFreeCustomFlexibleSpaceBar({super.key,required this.m4uFreeDetail});
  @override
  M4UFreeCustomFlexibleSpaceBarState createState() {
    return M4UFreeCustomFlexibleSpaceBarState();
  }
}

class M4UFreeCustomFlexibleSpaceBarState extends State<M4UFreeCustomFlexibleSpaceBar> {
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
            widget.m4uFreeDetail!.imageURL!,
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
                title: widget.m4uFreeDetail.title!,
                maxlines: 4,
                horizontalpadding: 20,
              ),
              SizedBox(height: 2.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.m4uFreeDetail.genre!.split(" ").length,
                        (index) => CustomText(
                      title: widget.m4uFreeDetail.genre!.split(" ")[index] + " ",
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
                    content: widget.m4uFreeDetail.released!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'RunTime',
                    content:
                    widget.m4uFreeDetail.runtime!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Director',
                    content: widget.m4uFreeDetail.director!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Quality',
                    content: widget.m4uFreeDetail.quality!,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildColumnInfo(
                    title: 'Director',
                    content: widget.m4uFreeDetail.director!,
                  ),
                  SizedBox(width: 4.w),
                  BuildColumnInfo(
                    title: 'Quality',
                    content: widget.m4uFreeDetail.quality!,
                  ),
                ],
              ),

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
