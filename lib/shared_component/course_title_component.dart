import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/shared_component/default_text_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../screens/lecture_screen.dart';

class CourseTitleComponent extends StatefulWidget {
  final String rankValue;
  const CourseTitleComponent({super.key, required this.rankValue});

  @override
  State<CourseTitleComponent> createState() => _CourseTitleComponentState();
}

class _CourseTitleComponentState extends State<CourseTitleComponent> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rankValue)
        .orderBy('createdDate', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureCall,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          }

          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return const Center(
              child: Text('No categories found'),
            );
          }

          var courses = List<Course>.from(snapshot.data?.docs
                  .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 115,
              ),
              itemCount: courses.length,
              itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LectureScreen(
                          course: courses[index],
                        ),
                      ));
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: ColorUtility.grey,
                    borderRadius: BorderRadius.all(Radius.circular(42)),
                  ),
                  child: Center(
                    child: textInApp(
                        text: courses[index].title ?? "No title",
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
