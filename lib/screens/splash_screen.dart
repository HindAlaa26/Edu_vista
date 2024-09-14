import 'package:edu_vista/screens/auth_screens/login_screen.dart';
import 'package:edu_vista/screens/layout_screens/home_layout_screen.dart';
import 'package:edu_vista/screens/onboarding/onboarding_screen.dart';
import 'package:edu_vista/services/pref_service.dart';
import 'package:edu_vista/utils/images_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            const Padding(
              padding: EdgeInsets.only(left: 100, right: 100),
              child: LinearProgressIndicator(
                color: Colors.blueGrey,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _startApp() async {
    await Future.delayed(const Duration(seconds: 6));
    if (mounted) {
      if (PreferencesService.isOnBoardingSeen) {
        if (FirebaseAuth.instance.currentUser != null) {
          if (PreferencesService.isLogin) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeLayoutScreen(),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
          }
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardingScreen(),
            ));
      }
    }
  }
}
