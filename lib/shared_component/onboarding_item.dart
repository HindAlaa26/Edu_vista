import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';

Widget onBoardingItem({
  required String imagePath,
  required String title,
  required double titleSize,
  required FontWeight titleWeight,
  required String subTitle,
  required double subTitleSize,
  required FontWeight subTitleWeight,
}) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Image.asset(imagePath),
    const SizedBox(height: 30),
    Text(
      title,
      style: TextStyle(fontSize: titleSize, fontWeight: titleWeight),
    ),
    const SizedBox(height: 20),
    Text(
      subTitle,
      style: TextStyle(
        fontSize: subTitleSize,
        fontWeight: subTitleWeight,
      ),
      textAlign: TextAlign.center,
    ),
  ]);
}
