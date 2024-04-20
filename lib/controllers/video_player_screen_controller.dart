
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreenController extends GetxController
{
  late FlickManager flickManager;
  Rx<BoxFit> flickVideoPlayerBoxfit = BoxFit.fill.obs;
  int currentBoxFitIndex = 0;

  initFlickVideoPlayer(String url,String title,{Map<String,String>? headers})
  {
    currentBoxFitIndex = 0;
    flickManager = FlickManager(
        videoPlayerController:
        VideoPlayerController.networkUrl(Uri.parse(url),httpHeaders: headers!));
  }

}