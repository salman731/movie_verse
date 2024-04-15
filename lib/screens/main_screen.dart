import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/screens/details_screen/details_screen.dart';
import 'package:Movieverse/screens/home_screen/main_home_screen.dart';
import 'package:Movieverse/screens/search_screen/search_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;
  PageController? _pageController;

  HomeScreenController homeScreenController = Get.put(HomeScreenController());


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }


  @override
  void dispose() {
    _pageController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        homeScreenController.loadPrimewireHomeScreen();

      },child: Icon(Icons.add),),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            MainHomeScreen(),
            SearchScreen(),
            Container(color: Colors.green,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: AppColors.black,

        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: AppColors.red,
              inactiveColor: AppColors.red.shade400,
              title: Text('Home'),
              icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
              activeColor: AppColors.red,
              inactiveColor: AppColors.red.shade400,
              title: Text('Search'),
              icon: Icon(Icons.search)
          ),
          BottomNavyBarItem(
              activeColor: AppColors.red,
              inactiveColor: AppColors.red.shade400,
              title: Text('Settings'),
              icon: Icon(Icons.settings)
          ),
          // BottomNavyBarItem(
          //     activeColor: AppColors.red,
          //     inactiveColor: AppColors.red.shade400,
          //     title: Text('Item Four'),
          //     icon: Icon(Icons.settings)
          // ),
        ],
      ),
    );
  }
}
