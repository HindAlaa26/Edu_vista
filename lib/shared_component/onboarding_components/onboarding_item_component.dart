import 'package:edu_vista/shared_component/default_text_component .dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget onBoardingItem({
  required String imagePath,
  required String title,
  required String subTitle,
}) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Image.asset(
          imagePath,
        ),
      ),
    ),
    SizedBox(height: 30.h),
    Expanded(
      child: textInApp(
        text: title,
      ),
    ),
    Expanded(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 5.h),
          child: textInApp(
              text: subTitle, fontSize: 16.sp, fontWeight: FontWeight.w300)),
    ),
  ]);
}
