

import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class ServerListDialog
{
  static bool? isLoaderShowing = false;
  static String? title;
  static bool decodeIframe = false;
  static bool isVideotoEmbededAllowed = false;

  static stopServerListDialog()
  {
    if(isLoaderShowing!)
    {
      Navigator.of(navigatorKey.currentContext!,rootNavigator: false).pop();
    }
  }

  static showServerListDialog(BuildContext context,Map<String,List<String>> map,String movieTitle,{bool decodeiframe = true,bool videotoIframeAllowed = false}){

    if (map.isNotEmpty) {
      isLoaderShowing = true;
      title = movieTitle;
      decodeIframe = decodeiframe;
      isVideotoEmbededAllowed = videotoIframeAllowed;
      AlertDialog alert=AlertDialog(
        title: Text("Select Server"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("Cancel"))
        ],
        content: SingleChildScrollView(
          child: new Column(
            children: populateServerButtons(map),),
        ),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }
    else{
      Fluttertoast.showToast(msg: "No servers found.Try different sources....",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
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
    String providerUrl;
    if (decodeIframe) {
      providerUrl = await LocalUtils.decodeUpMoviesIframeEmbedUrl(pageUrl);
    }
    else
      {
        providerUrl = (await WebUtils.getOriginalUrl(pageUrl))!;
      }
    VideoHosterEnum videoHosterEnum = VideoHosterEnum.values.firstWhere((e) => e.toString() == 'VideoHosterEnum.' + server);
    switch(videoHosterEnum)
    {
      case VideoHosterEnum.Voe:
        await VideoHostProviderUtils.getM3U8UrlFromVoeSX(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.Vidoza:
        await VideoHostProviderUtils.getMp4UrlFromVidoza(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.VidMoly:
        await VideoHostProviderUtils.getM3U8UrlFromVidMoly(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.UpStream:
        await VideoHostProviderUtils.getM3U8UrlfromUpStream(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.StreamWish:
        await VideoHostProviderUtils.getM3U8UrlFromStreamWish(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.StreamVid:
        await VideoHostProviderUtils.getM3U8UrlFromStreamVid(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.StreamTape:
        await VideoHostProviderUtils.getMp4UrlFromStreamTape(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.MixDrop:
        await VideoHostProviderUtils.getMp4UrlfromMixDrop(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.FileLions:
        await VideoHostProviderUtils.getM3U8UrlFromFileLions(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.DropLoad:
        await VideoHostProviderUtils.getM3U8UrlfromDropLoad(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.Dood:
        await VideoHostProviderUtils.getMp4UrlFromDood(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.VTube:
        await VideoHostProviderUtils.getM3U8UrlfromVTube(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed);
      case VideoHosterEnum.ePlayVid:
        await VideoHostProviderUtils.getMp4UrlFromePlayVid(providerUrl, title!);
      default:
    }
  }


}