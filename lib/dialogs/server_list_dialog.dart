

import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/dialogs/loader_dialog.dart';
import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/models/all_movie_land/all_movie_land_server_links.dart';
import 'package:Movieverse/utils/web_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:Movieverse/utils/video_host_provider_utils.dart';
import 'package:Movieverse/widgets/custom_button.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:sizer/sizer.dart';

class ServerListDialog
{
  static bool? isLoaderShowing = false;
  static String? title;
  static bool decodeIframe = false;
  static bool isVideotoEmbededAllowed = false;
  static bool isDirectProviderLink1 = false;
  static Map<String,String>? film1kHeaders;

  static stopServerListDialog()
  {
    if(isLoaderShowing!)
    {
      Navigator.of(navigatorKey.currentContext!,rootNavigator: false).pop();
    }
  }

  static showServerListDialog(BuildContext context,Map<String,List<String>> map,String movieTitle,{bool decodeiframe = true,bool videotoIframeAllowed = false,bool isDirectProviderLink = false,Map<String,String>? headers}){

    if (map.isNotEmpty) {
      isLoaderShowing = true;
      title = movieTitle;
      decodeIframe = decodeiframe;
      isDirectProviderLink1 = isDirectProviderLink;
      isVideotoEmbededAllowed = videotoIframeAllowed;
      film1kHeaders = headers;
      AlertDialog alert=AlertDialog(
        backgroundColor: AppColors.black,
        title: Text("Select Server"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("Cancel",style: TextStyle(color: Colors.white),))
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

  static showServerLinksDialog_AllMovieLand(BuildContext buildContext,List<AllMovieLandServerLinks> allMovieLandServerLinks,String movieTitle)
  {
    if (allMovieLandServerLinks != null && allMovieLandServerLinks.isNotEmpty) {
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
                children: populateServerButtons_AllMovieLand(allMovieLandServerLinks),),
            ),
          );
      showDialog(barrierDismissible: false,
        context:buildContext,
        builder:(BuildContext context){
          return alert;
        },
      );
    }
    else{
      Fluttertoast.showToast(msg: "No servers found.Try different sources....",toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red );
    }
  }

  static Widget getServerButton(String server,String pageUrl,{int? index,bool isSourceOwnServers = false})
  {
    String btnTitle = "";
   if(index != null)
     {
       btnTitle = "Play (${server}" " ${index + 1})";
     }
   else
     {
       btnTitle = "Play (${server})";
     }
   return CustomButton(func: () async {
      LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Playing.....");
      if (!isSourceOwnServers) {
        await playVideo(pageUrl,server);
      } else {
        ExternalVideoPlayerLauncher.launchMxPlayer(
            pageUrl!, MIME.applicationVndAppleMpegurl, {
          "title": title,
        });
      }
      LoaderDialog.stopLoaderDialog();
    }, title: btnTitle,
      color: AppColors.red,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)),);
   /*return SizedBox(
     width: 200,
     child: OutlinedButton(onPressed: () async{
       LoaderDialog.showLoaderDialog(navigatorKey.currentContext!,text: "Playing.....");
       if (!isSourceOwnServers) {
         await playVideo(pageUrl,server);
       } else {
         ExternalVideoPlayerLauncher.launchMxPlayer(
             pageUrl!, MIME.applicationVndAppleMpegurl, {
           "title": title,
         });
       }
       LoaderDialog.stopLoaderDialog();
      }, child: Text(btnTitle),style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black12,
          foregroundColor: Colors.black,
          textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),),
   );*/
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
                      
                     btnList.add(getServerButton(mapEntry.key, mapEntry.value[i],index: i));
                     btnList.add(SizedBox(height: 2.h,));
                  }
              }
          }
      }
    return btnList;
  }

  static List<Widget> populateServerButtons_AllMovieLand(List<AllMovieLandServerLinks> list)
  {
    List<Widget> btnList =[];

    for(AllMovieLandServerLinks allMovieLandServerLinks in list)
      {
         for(MapEntry<String,String> mapEntry in allMovieLandServerLinks.qualityM3u8LinksMap!.entries)
           {
              btnList.add(getServerButton(allMovieLandServerLinks.title! + "(${mapEntry.key})",mapEntry.value,isSourceOwnServers: true));
           }
      }
     return btnList;
  }


  static Future<void> playVideo(String pageUrl,String server) async
  {
    String providerUrl;
    if (!isDirectProviderLink1) {
      if (decodeIframe) {
            providerUrl = await LocalUtils.decodeUpMoviesIframeEmbedUrl(pageUrl);
          }
          else
            {
              providerUrl = (await WebUtils.getOriginalUrl(pageUrl))!;
            }
    }
    else
      {
        providerUrl = pageUrl;
      }
    VideoHosterEnum videoHosterEnum = VideoHosterEnum.values.firstWhere((e) => e.toString() == 'VideoHosterEnum.' + server);
    switch(videoHosterEnum)
    {
      case VideoHosterEnum.Voe:
        await VideoHostProviderUtils.getM3U8UrlFromVoeSX(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.Vidoza:
        await VideoHostProviderUtils.getMp4UrlFromVidoza(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.VidMoly:
        await VideoHostProviderUtils.getM3U8UrlFromVidMoly(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.UpStream:
        await VideoHostProviderUtils.getM3U8UrlfromUpStream(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.Films5k:
      case VideoHosterEnum.StreamWish:
        await VideoHostProviderUtils.getM3U8UrlFromStreamWish(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.StreamVid:
        await VideoHostProviderUtils.getM3U8UrlFromStreamVid(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.StreamTape:
        await VideoHostProviderUtils.getMp4UrlFromStreamTape(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.MixDrop:
        await VideoHostProviderUtils.getMp4UrlfromMixDrop(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.FileLions:
        await VideoHostProviderUtils.getM3U8UrlFromFileLions(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.DropLoad:
        await VideoHostProviderUtils.getM3U8UrlfromDropLoad(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.Dood:
        await VideoHostProviderUtils.getMp4UrlFromDood(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.VTube:
        await VideoHostProviderUtils.getM3U8UrlfromVTube(providerUrl, title!,isVideotoEmbededAllowed: isVideotoEmbededAllowed,headers: film1kHeaders);
      case VideoHosterEnum.ePlayVid:
        await VideoHostProviderUtils.getMp4UrlFromePlayVid(providerUrl, title!);
      case VideoHosterEnum.FileMoon:
        await VideoHostProviderUtils.getM3U8UrlfromFileMoon(providerUrl, title!,headers: film1kHeaders);
      case VideoHosterEnum.VidHideVip:
        await VideoHostProviderUtils.getM3U8UrlFromVidHideVip(providerUrl, title!,headers: film1kHeaders);
      default:
    }
  }


}