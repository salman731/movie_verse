import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import 'custom_button.dart';
import 'custom_text.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback func;
  const CustomErrorWidget({
    super.key,
    required this.error,
    required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            title: error,
            horizontalpadding: 10,
            maxlines: 2,
          ),
          SizedBox(height: 4.h),
          Lottie.asset("assets/animations/error-404.json"),
          SizedBox(height: 4.h),
          CustomButton(func: func, title: 'Try Again !')
        ],
      ),
    );
  }
}
