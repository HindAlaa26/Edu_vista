import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/category_model.dart';
import '../models/course_model.dart';
import '../shared_component/course_widget.dart';
import '../shared_component/default_text_component .dart';

class SeeAllCategoryScreen extends StatefulWidget {
  const SeeAllCategoryScreen({super.key});

  @override
  State<SeeAllCategoryScreen> createState() => _SeeAllCategoryScreenState();
}

class _SeeAllCategoryScreenState extends State<SeeAllCategoryScreen> {
  var futureCall = FirebaseFirestore.instance.collection('categories').get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: textInApp(text: "Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: futureCall,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ColorUtility.secondary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: textInApp(text: 'Error occurred'),
            );
          }

          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return Center(
              child: textInApp(text: 'No categories found'),
            );
          }

          // Convert Firestore documents to a list of Category objects
          var categories = List<Category>.from(
            snapshot.data?.docs.map((e) {
                  var category = Category.fromJson({'id': e.id, ...e.data()});
                  print('Category ID: ${category.id}, Name: ${category.name}');
                  return category;
                }).toList() ??
                [],
          );

          return ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(
              width: 10.w,
            ),
            itemBuilder: (context, index) => ExpansionTileList(
              trailing: const Icon(Icons.double_arrow),
              children: [
                ExpansionTile(
                  title: Text('${categories[index].name}'),
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('courses')
                          .where('category.id',
                              isEqualTo: categories[index]
                                  .id) // Updated query to check nested field
                          .get(),
                      builder: (ctx, courseSnapshot) {
                        if (courseSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: ColorUtility.secondary),
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
                          print(
                              'No courses found for category: ${categories[index].id}');
                          return Center(
                            child: textInApp(text: 'No courses found'),
                          );
                        }

                        var courses = List<Course>.from(
                          courseSnapshot.data?.docs.map((e) {
                                var course =
                                    Course.fromJson({'id': e.id, ...e.data()});
                                print(
                                    'Course ID: ${course.id}, Title: ${course.title}');
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
