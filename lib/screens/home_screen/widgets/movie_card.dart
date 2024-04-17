import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/screens/details_screen/details_screen.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';



class MovieCard extends StatelessWidget {
  final String imgurl;
  final String title;
  final String tag;
  const MovieCard({
    required this.imgurl,
    //required this.rate,
    required this.title,
    this.tag = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: CachedNetworkImage(
              imageUrl: imgurl,
              errorWidget: (context, url, error) {
                return AspectRatio(
                  aspectRatio: 2.2 / 3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey, Colors.grey.shade100],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: CustomText(
                      title: 'No Image Found !',
                      size: 8,
                    )),
                  ),
                );
              },
              imageBuilder: (context, imageProvider) {
                return Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 2.2 / 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                    ),
                    // rating tag
                    if(tag.isNotEmpty)...[
                    Positioned(
                      left: 15,
                      top: 10,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.red,
                        ),
                        child: CustomText(
                          title: tag,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ]

                  ],
                );
              }),
        ),
        SizedBox(height: 1.h),
        Container(
          width: 45.w,
          child: CustomText(
            title: title,
            maxlines: 1,
            size: 10,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
