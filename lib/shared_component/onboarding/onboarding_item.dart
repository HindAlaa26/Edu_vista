import 'package:edu_vista/shared_component/default_text.dart';
import 'package:flutter/material.dart';

Widget onBoardingItem({
  required String imagePath,
  required String title,
  required String subTitle,
}) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Image.asset(
        imagePath,
      ),
    ),
    const SizedBox(height: 30),
    textInApp(text: title, fontSize: 20, fontWeight: FontWeight.w700),
    const SizedBox(height: 20),
    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: textInApp(
            text: subTitle, fontSize: 16, fontWeight: FontWeight.w300)),
  ]);
}
