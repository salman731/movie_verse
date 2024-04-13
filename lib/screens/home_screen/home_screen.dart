import 'dart:async';

import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/widgets/custom_error_widget.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';
import 'widgets/shimmer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _popularmoviescontroller = ScrollController();
  final ScrollController _recentmoviescontroller = ScrollController();
  final ScrollController _upcomingmoviescontroller = ScrollController();
  final InternetConnectionChecker _checker = InternetConnectionChecker();
  bool isOnline = false;
  late StreamSubscription<InternetConnectionStatus> listener;
  // void _onPopularMovieScroll() async {
  //   if (_popularmoviescontroller.position.atEdge) {
  //     if (_popularmoviescontroller.position.pixels != 0 && isOnline) {
  //       context.read<PopularMovieBloc>().add(LoadPopularMovieEvent());
  //     }
  //   }
  // }
  //
  // void _onRecentMovieScroll() {
  //   if (_recentmoviescontroller.position.atEdge) {
  //     if (_recentmoviescontroller.position.pixels != 0 && isOnline) {
  //       context.read<TrendingMovieBloc>().add(LoadTrendingMovieEvent());
  //     }
  //   }
  // }
  //
  // void _onUpcomingMovieScroll() {
  //   if (_upcomingmoviescontroller.position.atEdge) {
  //     if (_upcomingmoviescontroller.position.pixels != 0 && isOnline) {
  //       context.read<UpcomingMovieBloc>().add(LoadUpcomingMovieEvent());
  //     }
  //   }
  // }

  @override
  void initState() {
    // _popularmoviescontroller.addListener(_onPopularMovieScroll);
    // _recentmoviescontroller.addListener(_onRecentMovieScroll);
    // _upcomingmoviescontroller.addListener(_onUpcomingMovieScroll);
    listener = _checker.onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isOnline = true;
          break;
        case InternetConnectionStatus.disconnected:
          isOnline = false;
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // _popularmoviescontroller
    //   ..removeListener(_onPopularMovieScroll)
    //   ..dispose();
    // _recentmoviescontroller
    //   ..removeListener(_onRecentMovieScroll)
    //   ..dispose();
    // _upcomingmoviescontroller
    //   ..removeListener(_onUpcomingMovieScroll)
    //   ..dispose();
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /*FutureBuilder<MovieModel>(
          future: Future.delayed(Duration(seconds: 5)),
          builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const ShimmerWidget();
          case ConnectionState.done:
            return*/ SingleChildScrollView(
              child: Column(
                children: [
                  CarouselWidget(
                    list: [1,2,3,5,6],
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            title: 'Popular Movies',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          /*MovieListView(
                                  controller: _popularmoviescontroller,
                                  movies: list,
                                  hasReachedMax: true,
                                ),*/
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'Trending Movies',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          /*MovieListView(
                                  controller: _recentmoviescontroller,
                                  movies: list,
                                  hasReachedMax: true,
                                ),*/
                          SizedBox(
                            height: 2.h,
                          ),
                          const CustomText(
                            title: 'Upcoming Movies',
                            size: 12,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          /*MovieListView(
                                  controller: _upcomingmoviescontroller,
                                  movies: list,
                                  hasReachedMax: true,
                                ),*/
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ))
                ],
              ),
            )

          /*case ConnectionState.none:
            return CustomErrorWidget(
              error: "Error",
              func: () {
               
              },
            );
          case ConnectionState.active:
            // TODO: Handle this case.
        }
        return Container();
      })*/,
    );
  }

  Container _listviewErrorWidget(
      String error, BuildContext context, VoidCallback func) {
    return Container(
      height: 15.h,
      width: 100.w,
      color: Colors.grey.shade300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            title: error,
            size: 12,
            color: AppColors.deepbleu,
          ),
          TextButton(
              onPressed: func,
              child: const CustomText(
                title: 'try again !',
                color: AppColors.red,
                size: 8,
              ))
        ],
      ),
    );
  }
}
