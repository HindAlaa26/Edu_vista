import 'package:edu_vista/screens/see_all_courses_screen.dart';
import 'package:edu_vista/shared_component/default_text_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared_component/category_widget.dart';
import '../shared_component/course_component.dart';
import '../shared_component/home_label_shared_component.dart';
import '../shared_component/shopping_icon_widget.dart';
import 'see_all_category_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<String> coursesHeadlines = [
    "Students Also Search for",
    "Top Courses in IT",
    "Top Sellers"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            textInApp(text: "Welcome"),
            SizedBox(width: 8.w),
            textInApp(
                text: "${FirebaseAuth.instance.currentUser?.displayName}",
                color: ColorUtility.main),
          ],
        ),
        actions: [shoppingIcon()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              LabelWidget(
                name: 'Categories',
                onSeeAllClicked: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeeAllCategoryScreen(),
                      ));
                },
              ),
              const CategoriesWidget(),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => Column(
                          children: [
                            LabelWidget(
                              name: coursesHeadlines[index],
                              onSeeAllClicked: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeeAllCoursesScreen(
                                          rankValue: coursesHeadlines[index]),
                                    ));
                              },
                            ),
                            CourseComponent(
                              rankValue: coursesHeadlines[index],
                            ),
                          ],
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10.h,
                        ),
                    itemCount: coursesHeadlines.length),
              )
            ],
          ),
        ),
      ),
    );
  }
}
