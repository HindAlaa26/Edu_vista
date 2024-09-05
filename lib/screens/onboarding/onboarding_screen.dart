import 'package:edu_vista/screens/auth_screens/login_screen.dart';
import 'package:edu_vista/services/pref_service.dart';
import 'package:edu_vista/shared_component/default_button_component .dart';
import 'package:edu_vista/shared_component/default_text_component .dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:edu_vista/utils/images_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared_component/onboarding_components/onboarding_arrow_icon_component.dart';
import '../../shared_component/onboarding_components/onboarding_item_component.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentPage = 0;
  var onBoardingController = PageController(initialPage: 0);
  @override
  void dispose() {
    onBoardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    onBoardingController.animateToPage(3,
                        duration: const Duration(seconds: 1),
                        curve: Curves.decelerate);
                  },
                  child: textInApp(
                      text: "Skip",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff3A3A3A)),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: onBoardingController,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              children: [
                // item 1
                onBoardingItem(
                  title: "Certification and Badges",
                  imagePath: ImageUtility.certificationAndBadges,
                  subTitle:
                      "Earn a certificate after completion of every course",
                ),
                // item 2
                onBoardingItem(
                  title: "Progress Tracking",
                  imagePath: ImageUtility.progressTracking,
                  subTitle: "Check your Progress of every course",
                ),
                // item 3
                onBoardingItem(
                  title: "Offline Access",
                  imagePath: ImageUtility.offlineAccess,
                  subTitle: "Make your course available offline",
                ),
                // item 4
                onBoardingItem(
                  title: "Course Catalog",
                  imagePath: ImageUtility.courseCatalog,
                  subTitle: "View in which courses you are enrolled",
                ),
              ],
            ),
          ),
          currentPage == 3
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: defaultButton(
                      text: "Let's Start",
                      onTap: () {
                        onLogin();
                      }))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            4,
                            (index) => Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                      color: currentPage == index
                                          ? ColorUtility.secondary
                                          : const Color(0xff3A3A3A),
                                      borderRadius: BorderRadius.circular(128)),
                                  height: 7.h,
                                  width: 42.w,
                                ))),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 30.h, horizontal: 19.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ArrowIcon(
                            currentPage: currentPage,
                            isNext: false,
                            onBoardingController: onBoardingController,
                          ),
                          ArrowIcon(
                            currentPage: currentPage,
                            isNext: true,
                            onBoardingController: onBoardingController,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
        ],
      )),
    );
  }

  void onLogin() {
    PreferencesService.isOnBoardingSeen = true;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }
}
