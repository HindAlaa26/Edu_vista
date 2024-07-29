import 'package:edu_vista/utils/images_utility.dart';
import 'package:flutter/material.dart';

class SplashScree extends StatelessWidget {
  const SplashScree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageUtility.logo),
      ),
    );
  }
}
