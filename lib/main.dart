import 'package:edu_vista/screens/onboarding/onboarding_screen.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edu Vista',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "PlusJakartaSans",
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        scaffoldBackgroundColor: ColorUtility.scaffoldBackground,
        useMaterial3: true,
      ),
      home: OnBoardingScreen(),
    );
  }
}
