import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/controllers/video_player_screen_controller.dart';
import 'package:Movieverse/screens/video_player/widgets/landscape_player_controls.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  late String url;
  Map<String,String> headers;
  late String title;
  VideoPlayerScreen(this.url,this.title,{this.headers =  const <String, String>{},Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  VideoPlayerScreenController videoPlayerScreenController = Get.put(VideoPlayerScreenController());



  @override
  void initState() {
    super.initState();
    videoPlayerScreenController.initFlickVideoPlayer(widget.url, widget.title,headers: widget.headers);
  }


  @override
  void dispose() {
    super.dispose();
    //videoPlayerScreenController.flickManager.dispose();
  }

  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp]);
        videoPlayerScreenController.flickManager.dispose();
      },
      child: Scaffold(
        body: Obx(()=> FlickVideoPlayer(
            flickManager: videoPlayerScreenController.flickManager,
            preferredDeviceOrientation: [
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft
            ],
            systemUIOverlay: [],
            flickVideoWithControls: FlickVideoWithControls(
              videoFit: videoPlayerScreenController.flickVideoPlayerBoxfit.value,
              controls: LandscapePlayerControls(title: widget.title,),
            ),
          ),
        ),
      ),
    );
  }


}
