import 'package:edu_vista/shared_component/default_text_component%20.dart';
import 'package:flutter/material.dart';
import '../shared_component/course_component.dart';

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
