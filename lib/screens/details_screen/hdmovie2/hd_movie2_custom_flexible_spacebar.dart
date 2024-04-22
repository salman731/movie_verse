import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_detail.dart';
import 'package:Movieverse/models/hd_movie2/hd_movie2_detail.dart';
import 'package:Movieverse/models/primewire/prime_wire_detail.dart';
import 'package:Movieverse/models/up_movies/up_movie_detail.dart';
import 'package:Movieverse/screens/details_screen/widgets/favorite_button.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HdMovie2CustomFlexibleSpaceBar extends StatefulWidget {
  HdMovie2Detail hdMovie2Detail;
  HdMovie2CustomFlexibleSpaceBar({super.key,required this.hdMovie2Detail});
  @override
  HdMovie2CustomFlexibleSpaceBarState createState() {
    return HdMovie2CustomFlexibleSpaceBarState();
  }
}

class HdMovie2CustomFlexibleSpaceBarState extends State<HdMovie2CustomFlexibleSpaceBar> {
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
            widget.hdMovie2Detail.imageURL!,
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
                title: widget.hdMovie2Detail.title!,
                maxlines: 4,
                horizontalpadding: 20,
              ),
              SizedBox(height: 2.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.hdMovie2Detail.tags!.split(",").length,
                        (index) => CustomText(
                      title:  widget.hdMovie2Detail.tags!.split(",")[index] + " ",
                      color: Colors.grey,
                      size: 8,
                    ),
                  )),
              if(widget.hdMovie2Detail.ratings!.isNotEmpty && LocalUtils.isStringDouble(widget.hdMovie2Detail.ratings!))...[
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: List.generate(
                          double.parse(widget.hdMovie2Detail.ratings!).toInt()+ 1,
                              (index) => Icon(
                            index == double.parse(widget.hdMovie2Detail.ratings!).toInt()
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
                        title: widget.hdMovie2Detail.ratings!,
                        size: 8,
                      ),
                    )
                  ],
                ),
              ],
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCoulmnInfo(
                    title: 'Runtime',
                    content: widget.hdMovie2Detail.duration!.trim().isEmpty ? "N/A" : widget.hdMovie2Detail.duration! ,
                  ),
                  SizedBox(width: 4.w),
                  _buildCoulmnInfo(
                    title: 'Released Date',
                    content:
                    widget.hdMovie2Detail.releasedDate!.trim().isEmpty ? "N/A" : widget.hdMovie2Detail.releasedDate!,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 4.w),
                  _buildCoulmnInfo(
                    title: 'Country',
                    content:
                    widget.hdMovie2Detail.country!.trim().isEmpty ? "N/A" : widget.hdMovie2Detail.country!,
                  ),
                  SizedBox(width: 4.w),
                  _buildCoulmnInfo(
                    title: 'Director',
                    content:
                    widget.hdMovie2Detail.director!.trim().isEmpty ? "N/A" : widget.hdMovie2Detail.director!,
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
          maxlines: 3,
        ),
      ],
    );
  }
}
