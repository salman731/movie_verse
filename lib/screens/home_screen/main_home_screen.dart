import 'dart:async';
import 'dart:ffi';

import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/controllers/search_screen_controller.dart';
import 'package:Movieverse/dialogs/source_list_dialog.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/screens/home_screen/all_movie_land_home_screen_widget.dart';
import 'package:Movieverse/screens/home_screen/film_1k_home_screen_widget.dart';
import 'package:Movieverse/screens/home_screen/pr_movies_home_screen_widget.dart';
import 'package:Movieverse/screens/home_screen/primewire_home_screen_widget.dart';
import 'package:Movieverse/screens/home_screen/up_movies_home_screen_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/carousel_widget.dart';
import 'package:Movieverse/screens/home_screen/widgets/movie_listview.dart';
import 'package:Movieverse/utils/shared_prefs_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:Movieverse/widgets/custom_error_widget.dart';
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:Movieverse/widgets/source_search_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'widgets/shimmer_widget.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final ScrollController _popularmoviescontroller = ScrollController();
  final ScrollController _recentmoviescontroller = ScrollController();
  final ScrollController _upcomingmoviescontroller = ScrollController();
  final InternetConnectionChecker _checker = InternetConnectionChecker();
  bool isOnline = false;
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  SearchScreenController searchScreenController = Get.put(SearchScreenController());
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
    searchScreenController.initWebViewController();
    Get.find<HomeScreenController>().selectedSource.value = SourceEnum.values.firstWhere((e) => e.toString() == 'SourceEnum.' + SharedPrefsUtil.getString(SharedPrefsUtil.KEY_SELECTED_SOURCE,defaultValue: SourceEnum.UpMovies.name));
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
    return GetBuilder<HomeScreenController>(
      id: "updateHomeScreen",
      builder: (_){
        return Scaffold(
          floatingActionButton: Obx(()=> FloatingActionButton.extended(onPressed: (){
              SourceListDialog.showSourceListDialog(context);
            }, label: Text(homeScreenController.selectedSource.value.name),backgroundColor: AppColors.red,icon: Icon(Icons.segment_rounded),),
          ),/*FloatingActionButton(onPressed: (){
            homeScreenController.loadFilm1kHomeScreen();
          },child: Icon(Icons.add),),*/
            body:Column(children:[
              SizedBox(height:0,width:0,child: WebViewWidget(controller: searchScreenController.webViewController!,)),
              Expanded(child: getSource(homeScreenController.selectedSource.value))
            ]),
        );
      },

    );
  }

  Widget getSource(SourceEnum selectedSource)
  {
    switch(selectedSource)
    {
      case SourceEnum.UpMovies:
        return UpMoviesHomeScreenWidget();
      case SourceEnum.Primewire:
        return PrimewireHomeScreenWidget();
      case SourceEnum.Film1k:
        return Film1kHomeScreenWidget();
      case SourceEnum.AllMovieLand:
        return AllMovieLandHomeScreenWidget();
      case SourceEnum.PrMovies:
        return PrMoviesHomeScreenWidget();
    }
    return Container();
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
