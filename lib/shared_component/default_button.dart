import 'package:edu_vista/shared_component/default_text.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  required String text,
  required void Function() onTap,
}) {
  return MaterialButton(
      minWidth: 316,
      height: 57,
      color: ColorUtility.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onPressed: onTap,
      child: textInApp(
          text: text,
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w700));
}
