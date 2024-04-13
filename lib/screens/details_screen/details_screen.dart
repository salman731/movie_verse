/*
import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/screens/details_screen/widgets/back_button.dart';
import 'package:Movieverse/screens/details_screen/widgets/custom_flexible_spacebar.dart';
import 'package:Movieverse/screens/details_screen/widgets/search_button.dart';
import 'package:Movieverse/widgets/custom_button.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:sizer/sizer.dart';

import '../../widgets/custom_error_widget.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return */
/*BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, moviestate) {
        if (moviestate is MovieDetailsLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.green,
          ));
        } else if (moviestate is MovieDetailsSuccess) {
          return*//*
 Scaffold(
              body: CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  CustomSearchButton()
                ],
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: const CustomBackButton(),
                flexibleSpace: CustomFlexibleSpaceBar(),
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
                          text: 'Overview : ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.amber,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                          children: [
                            TextSpan(
                              text: "Overview 1",
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
                          text: 'Casts: ',
                          style:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.amber,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          children: [
                            TextSpan(
                              text: "Overview 1",
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
                            value: 'Item 1',
                            onChanged: (String? newValue) {
                            },
                            items: <String>['Item 1', 'Item 2', 'Item 3', 'Item 4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.white, // Dropdown text color
                                  ),
                                ),
                              );
                            }).toList(),
                            dropdownColor: Colors.black, // Dropdown background color
                            underline: SizedBox(), // Remove default underline
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Center(
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
                            value: 'Item 1',
                            iconEnabledColor: AppColors.red,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                            },
                            items: <String>['Item 1', 'Item 2', 'Item 3', 'Item 4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            dropdownColor: Colors.black, // Dropdown background color
                            underline: SizedBox(), // Remove default underline
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: CustomButton(func: (){}, title: "Play",
                          color: AppColors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),),
                      ),
                      */
/*const CustomText(
                        title: 'Cast ',
                        size: 12,
                      ),
                     // const CastWidget(),
                      const CustomText(
                        title: 'Screenshots ',
                        size: 12,
                      ),*//*

                      //const ScreenshotWidget(),
                      SizedBox(height: 2.h),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ]))
            ],
          ));
        */
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
    );*//*

  }
}
*/
