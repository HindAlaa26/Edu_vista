import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../models/course_model.dart';
import '../../shared_component/course_component/course_component.dart';
import '../../shared_component/default_text.dart';
import '../../utils/color_utility.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: textInApp(text: widget.category.name ?? ""),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('courses')
              .where('category.id', isEqualTo: widget.category.id)
              .get(),
          builder: (ctx, courseSnapshot) {
            if (courseSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: ColorUtility.secondary),
              );
            }

            if (courseSnapshot.hasError) {
              print('Error: ${courseSnapshot.error}');
              return Center(
                child: textInApp(text: 'Error loading courses'),
              );
            }

            if (!courseSnapshot.hasData ||
                (courseSnapshot.data?.docs.isEmpty ?? false)) {
              print('No courses found for category: ${widget.category.id}');
              return Center(
                child: textInApp(text: 'No courses found'),
              );
            }

            var courses = List<Course>.from(
              courseSnapshot.data?.docs.map((e) {
                    var course = Course.fromJson({'id': e.id, ...e.data()});
                    print('Course ID: ${course.id}, Title: ${course.title}');
                    return course;
                  }).toList() ??
                  [],
            );

            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: courseWidget(
                context: context,
                isSeeAll: true,
                courses: courses,
              ),
            );
          },
        ),
      ),
    );
  }
}
