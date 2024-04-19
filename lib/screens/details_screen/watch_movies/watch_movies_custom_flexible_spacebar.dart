import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_detail.dart';
import 'package:Movieverse/models/pr_movies/pr_movies_detail.dart';
import 'package:Movieverse/models/primewire/prime_wire_detail.dart';
import 'package:Movieverse/models/up_movies/up_movie_detail.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_detail.dart';
import 'package:Movieverse/screens/details_screen/widgets/favorite_button.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class WatchMoviesCustomFlexibleSpaceBar extends StatefulWidget {
  WatchMoviesDetail watchMoviesDetail;
  WatchMoviesCustomFlexibleSpaceBar({super.key,required this.watchMoviesDetail});
  @override
  WatchMoviesCustomFlexibleSpaceBarState createState() {
    return WatchMoviesCustomFlexibleSpaceBarState();
  }
}

class WatchMoviesCustomFlexibleSpaceBarState extends State<WatchMoviesCustomFlexibleSpaceBar> {
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
            widget.watchMoviesDetail.imageURL!,
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
                title: widget.watchMoviesDetail.title!,
                maxlines: 4,
                horizontalpadding: 20,
              ),
              SizedBox(height: 2.h),
              /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.watchMoviesDetail.genre!.split(",").length,
                        (index) => CustomText(
                      title:  widget.watchMoviesDetail.genre!.split(",")[index] + " ",
                      color: Colors.grey,
                      size: 8,
                    ),
                  )),

              SizedBox(height: 2.h),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCoulmnInfo(
                    title: 'Duration',
                    content: widget.watchMoviesDetail.duration!.trim().isEmpty ? "N/A" : widget.watchMoviesDetail.duration! ,
                  ),
                  SizedBox(width: 4.w),
                  _buildCoulmnInfo(
                    title: 'Director',
                    content:
                    widget.watchMoviesDetail.director!.trim().isEmpty ? "N/A" : widget.watchMoviesDetail.director!,
                  ),
                  SizedBox(width: 4.w),
                  _buildCoulmnInfo(
                    title: 'Added Date',
                    content:
                    widget.watchMoviesDetail.addedDate!.trim().isEmpty ? "N/A" : widget.watchMoviesDetail.addedDate!,
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
