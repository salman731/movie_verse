import 'package:Movieverse/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomSearchButton extends StatelessWidget {
  const CustomSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
            )),
        child: IconButton(
            onPressed: () {

            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            )));
  }
}
