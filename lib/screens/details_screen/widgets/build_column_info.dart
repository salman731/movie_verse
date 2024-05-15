
import 'package:Movieverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BuildColumnInfo extends StatelessWidget {
  String? title;
  String? content;
  BuildColumnInfo({this.title,this.content,super.key});

  @override
  Widget build(BuildContext context) {
      return Expanded(
        child: Column(
          children: [
            CustomText(
              title: title!,
              color: Colors.grey,
              size: 8,
            ),
            SizedBox(
              height: 1.h,
            ),
            CustomText(
              title: content!,
              size: 10,
            ),
          ],
        ),
      );

  }
}
