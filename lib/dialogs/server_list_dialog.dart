

import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class ServerListDialog
{
  static bool? isLoaderShowing = false;
  static String? title;

  static stopServerListDialog()
  {
    if(isLoaderShowing!)
    {
      Navigator.of(navigatorKey.currentContext!,rootNavigator: false).pop();
    }
  }

  static showServerListDialog(BuildContext context,Map<String,List<String>> map,String movieTitle){

    isLoaderShowing = true;
    title = movieTitle;
    AlertDialog alert=AlertDialog(
      title: Text("Select Server"),
      actions: [
        TextButton(onPressed: (){
          Get.back();
        }, child: Text("Cancel"))
      ],
      content: SingleChildScrollView(
        child: new Column(
          children: populateServerButtons(map)

          ,),
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  static Widget getServerButton(String server,String pageUrl,int index)
  {
   return SizedBox(
     width: 200,
     child: OutlinedButton(onPressed: () async{
       LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Playing.....");
       await playVideo(pageUrl,server);
       LoaderDialog.stopLoaderDialog();
      }, child: Text("Play (${server}" " ${index + 1})"),style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black12,
          foregroundColor: Colors.black,
          textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),),
   );
  }

  static List<Widget> populateServerButtons(Map<String,List<String>> map)
  {
    List<Widget> btnList =[];
    for (MapEntry<String,List<String>> mapEntry in map.entries)
      {
        for (VideoHosterEnum videoHosterEnum in VideoHosterEnum.values)
          {
            if(mapEntry.key == videoHosterEnum.name)
              {
                for(int i = 0;i<mapEntry.value.length;i++)
                  {
                     btnList.add(getServerButton(mapEntry.key, mapEntry.value[i],i));
                  }
              }
          }
      }
    return btnList;
  }

  static Future<void> playVideo(String pageUrl,String server) async
  {
    String providerUrl = await LocalUtils.decodeUpMoviesIframeEmbedUrl(pageUrl);
    VideoHosterEnum videoHosterEnum = VideoHosterEnum.values.firstWhere((e) => e.toString() == 'VideoHosterEnum.' + server);
    switch(videoHosterEnum)
    {
      case VideoHosterEnum.VoeSX:
        await VideoHostProviderUtils.getM3U8UrlFromVoeSX(providerUrl, title!);
      case VideoHosterEnum.Vidoza:
        await VideoHostProviderUtils.getMp4UrlFromVidoza(providerUrl, title!);
      case VideoHosterEnum.VidMoly:
        await VideoHostProviderUtils.getM3U8UrlFromVidMoly(providerUrl, title!);
      case VideoHosterEnum.UpStream:
        await VideoHostProviderUtils.getM3U8UrlfromUpStream(providerUrl, title!);
      case VideoHosterEnum.StreamWish:
        await VideoHostProviderUtils.getM3U8UrlFromStreamWish(providerUrl, title!);
      case VideoHosterEnum.StreamVid:
        await VideoHostProviderUtils.getM3U8UrlFromStreamVid(providerUrl, title!);
      case VideoHosterEnum.StreamTape:
        await VideoHostProviderUtils.getMp4UrlFromStreamTape(providerUrl, title!);
      case VideoHosterEnum.MixDrop:
        await VideoHostProviderUtils.getMp4UrlfromMixDrop(providerUrl, title!);
      case VideoHosterEnum.FileLions:
        await VideoHostProviderUtils.getM3U8UrlFromFileLions(providerUrl, title!);
      case VideoHosterEnum.DropLoad:
        await VideoHostProviderUtils.getM3U8UrlfromDropLoad(providerUrl, title!);
      case VideoHosterEnum.Dood:
        await VideoHostProviderUtils.getMp4UrlFromDood(providerUrl, title!);
      case VideoHosterEnum.VTubeTo:
        await VideoHostProviderUtils.getM3U8UrlfromVTube(providerUrl, title!);
      case VideoHosterEnum.ePlayVid:
        await VideoHostProviderUtils.getMp4UrlFromePlayVid(providerUrl, title!);
      default:
    }
  }
}