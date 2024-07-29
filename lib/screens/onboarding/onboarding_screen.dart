import 'package:edu_vista/shared_component/onboarding_item.dart';
import 'package:edu_vista/utils/images_utility.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          // item 1
          onBoardingItem(
              title: "Certification and Badges",
              imagePath: ImageUtility.certificationAndBadges,
              titleSize: 20,
              titleWeight: FontWeight.w700,
              subTitle: "Earn a certificate after completion of every course",
              subTitleSize: 16,
              subTitleWeight: FontWeight.w300),
          // item 2
          onBoardingItem(
              title: "Progress Tracking",
              imagePath: ImageUtility.progressTracking,
              titleSize: 20,
              titleWeight: FontWeight.w700,
              subTitle: "Check your Progress of every course",
              subTitleSize: 16,
              subTitleWeight: FontWeight.w300),
          // item 3
          onBoardingItem(
              title: "Offline Access",
              imagePath: ImageUtility.offlineAccess,
              titleSize: 20,
              titleWeight: FontWeight.w700,
              subTitle: "Make your course available offline",
              subTitleSize: 16,
              subTitleWeight: FontWeight.w300),
          // item 4
          onBoardingItem(
              title: "Course Catalog",
              imagePath: ImageUtility.courseCatalog,
              titleSize: 20,
              titleWeight: FontWeight.w700,
              subTitle: "View in which courses you are enrolled",
              subTitleSize: 16,
              subTitleWeight: FontWeight.w300),
        ],
      ),
    );
  }
}
