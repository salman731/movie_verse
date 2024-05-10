
import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/home_screen_controller.dart';
import 'package:Movieverse/enums/source_enum.dart';
import 'package:Movieverse/main.dart';
import 'package:Movieverse/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SourceListDialog
{
  static RxString? selectedOption = SourceEnum.UpMovies.name.obs;

  static showSourceListDialog(BuildContext context){

      selectedOption!.value = SharedPrefsUtil.getString(SharedPrefsUtil.KEY_SELECTED_SOURCE,defaultValue: SourceEnum.UpMovies.name);
      AlertDialog alert=AlertDialog(
        backgroundColor: AppColors.black,
        title: Text("Select Source"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("Cancel",)),
          TextButton(onPressed: (){
            Get.find<HomeScreenController>().selectedSource.value = SourceEnum.values.firstWhere((e) => e.toString() == 'SourceEnum.' + selectedOption!.value);
            Get.find<HomeScreenController>().updateSource();
            SharedPrefsUtil.setString(SharedPrefsUtil.KEY_SELECTED_SOURCE, selectedOption!.value);
            Get.back();
          }, child: Text("Ok",)),

        ],
        content: Obx(()=>SingleChildScrollView(
          child: Column(
              children: [
                for (SourceEnum sourceEnum in SourceEnum.values)...
                [
                  RadioListTile<String>(
                    title: Text(sourceEnum.name,style: TextStyle(color: Colors.white),),
                    value: sourceEnum.name,
                    groupValue: selectedOption!.value,
                    onChanged: (value) {
                      selectedOption!.value = value!;
                    },
                  ),
                ],
               /* RadioListTile<String>(
                  title: Text('UpMovies',style: TextStyle(color: Colors.white),),
                  value: SourceEnum.UpMovies.name,
                  groupValue: selectedOption!.value,
                  onChanged: (value) {
                      selectedOption!.value = value!;
          
                  },
                ),
                RadioListTile<String>(
                  title: Text('Primewire',style: TextStyle(color: Colors.white)),
                  value: SourceEnum.Primewire.name,
                  groupValue: selectedOption!.value,
                  onChanged: (value) {
                      selectedOption!.value = value!;
                  },
                ),
                RadioListTile<String>(
                  title: Text('AllMovieLand',style: TextStyle(color: Colors.white)),
                  value: SourceEnum.AllMovieLand.name,
                  groupValue: selectedOption!.value,
                  onChanged: (value) {
                      selectedOption!.value = value!;
                  },
                ),
                RadioListTile<String>(
                  title: Text('PrMovies',style: TextStyle(color: Colors.white)),
                  value: SourceEnum.PrMovies.name,
                  groupValue: selectedOption!.value,
                  onChanged: (value) {
                    selectedOption!.value = value!;
                  },
                ),
                RadioListTile<String>(
                  title: Text('Film1k',style: TextStyle(color: Colors.white)),
                  value: SourceEnum.Film1k.name,
                  groupValue: selectedOption!.value,
                  onChanged: (value) {
                    selectedOption!.value = value!;
                  },
                ),
                RadioListTile<String>(
                  title: Text('WatchMovies',style: TextStyle(color: Colors.white)),
                  value: SourceEnum.WatchMovies.name,
                  groupValue: selectedOption!.value,
                  onChanged: (value) {
                    selectedOption!.value = value!;
                  },
                ),
                RadioListTile<String>(
                  title: Text('HdMovie2',style: TextStyle(color: Colors.white)),
                  value: SourceEnum.HdMovie2.name,
                  groupValue: selectedOption!.value,
                  onChanged: (value) {
                    selectedOption!.value = value!;
                  },
                ),*/
              ],),
        ),
        ),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );

  }
}