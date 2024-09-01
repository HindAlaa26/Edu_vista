import 'package:edu_vista/main.dart';
import 'package:edu_vista/shared_component/default_text_component .dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget defaultButton({
  required String text,
  required void Function() onTap,
  Color color = ColorUtility.secondary,
  Color textColor = Colors.white,
}) {
  return MaterialButton(
      minWidth: 316.w,
      height: 57.h,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onPressed: onTap,
      child: textInApp(
          text: text,
          fontSize: 18.sp,
          color: textColor,
          fontWeight: FontWeight.w700));
}
