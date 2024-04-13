

import 'package:Movieverse/screens/home_screen/home_screen.dart';
import 'package:Movieverse/screens/main_screen.dart';
import 'package:Movieverse/screens/main_screen_2.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/splash_logo.png',
      nextScreen: MainScreen2(),
      splashIconSize: 256,
      splashTransition: SplashTransition.rotationTransition,
      //pageTransitionType: PageTransitionType.rotate,
    );
  }
}

