import 'package:edu_vista/screens/auth_screens/login_screen.dart';
import 'package:edu_vista/screens/onboarding/onboarding_screen.dart';
import 'package:edu_vista/services/pref_service.dart';
import 'package:edu_vista/utils/images_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_loadingkit/flutter_animated_loadingkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageUtility.logo),
            SizedBox(
              height: 100.h,
            ),
            const AnimatedLoadingSpiralLines(
              color: Colors.blueGrey,
              baseRadius: 7,
            )
          ],
        ),
      ),
    );
  }

  void _startApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      if (PreferencesService.isOnBoardingSeen) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnBoardingScreen(),
            ));
      }
    }
  }
}
