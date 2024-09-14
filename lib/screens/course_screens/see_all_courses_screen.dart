import 'package:flutter/material.dart';
import '../../shared_component/course_component/course_component.dart';
import '../../shared_component/default_text.dart';

class SeeAllCoursesScreen extends StatelessWidget {
  final String rankValue;
  const SeeAllCoursesScreen({super.key, required this.rankValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: textInApp(text: rankValue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CourseComponent(
          rankValue: rankValue,
          isSeeAll: true,
        ),
      ),
    );
  }
}
