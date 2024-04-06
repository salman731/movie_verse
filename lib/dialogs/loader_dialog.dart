
import 'package:Movieverse/main.dart';
import 'package:flutter/material.dart';

class LoaderDialog
{
  static bool? isLoaderShowing = false;

  static stopLoaderDialog()
  {
    if(isLoaderShowing!)
      {
        Navigator.of(navigatorKey.currentContext!,rootNavigator: false).pop();
        isLoaderShowing = false;
      }
  }

  static showLoaderDialog(BuildContext context,{String text = "Loading..."}){

    if (!isLoaderShowing!) {
      isLoaderShowing = true;
      AlertDialog alert=AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 7),child:Text(text)),
          ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }
  }
}