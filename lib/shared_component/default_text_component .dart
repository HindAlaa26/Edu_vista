import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget textInApp({
  required String text,
  double fontSize = 20,
  Color color = ColorUtility.black,
  FontWeight fontWeight = FontWeight.w700,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp,
    ),
    textAlign: TextAlign.center,
  );
}
