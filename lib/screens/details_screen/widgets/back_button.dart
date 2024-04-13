import 'package:Movieverse/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
            )),
        child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )));
  }
}
