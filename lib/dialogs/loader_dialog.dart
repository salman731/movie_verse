
import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoaderDialog
{
  static bool? isLoaderShowing = false;

  static stopLoaderDialog()
  {
    if(isLoaderShowing!)
      {
        Get.back();
        isLoaderShowing = false;
      }
  }

  static showLoaderDialog(BuildContext context,{String text = "Loading..."}) async{

    if (!isLoaderShowing!) {
      isLoaderShowing = true;
      AlertDialog alert=AlertDialog(
        backgroundColor: AppColors.black,
        content: new Row(
          children: [
            CircularProgressIndicator(color: AppColors.red,),
            Container(margin: EdgeInsets.only(left: 7),child:Text(text,style: TextStyle(color: AppColors.red),)),
          ],),
      );
      await showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
      isLoaderShowing = false;
    }
  }
}