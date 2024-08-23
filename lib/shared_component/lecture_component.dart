import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/course_model.dart';
import '../models/lecture_model.dart';
import '../utils/app_enum.dart';
import '../utils/color_utility.dart';
import 'default_text_component .dart';

class LecturesWidget extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;
  // final void Function(Lecture) onLectureChosen;
  const LecturesWidget(
      {required this.course,
      // required this.onLectureChosen,
      super.key,
      required this.courseOption});

  @override
  State<LecturesWidget> createState() => _LecturesWidgetState();
}

class _LecturesWidgetState extends State<LecturesWidget> {
  int selectedLectureIndex = 0;
  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.lecture:
        return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('courses')
                .doc(widget.course.id)
                .collection('lectures')
                .get(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorUtility.secondary,
                  ),
                );
              }

              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');

                return Center(
                  child: textInApp(text: 'Error occurred'),
                );
              }

              if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
                print('No data found or empty lectures list');
                return Center(
                  child: textInApp(
                    text: 'No Lectures found',
                  ),
                );
              }
              print('Lectures Data: ${snapshot.data?.docs}');
              var lectures = List<Lecture>.from(snapshot.data?.docs
                      .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
                      .toList() ??
                  []);

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: lectures.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemBuilder: (context, index) {
                  return buildLectureItem(
                      title: lectures[index].title ?? "Lecture title",
                      isActive: index == selectedLectureIndex,
                      subtitle:
                          lectures[index].description ?? "Lecture description",
                      lectureNumber: lectures[index].sort ?? 1,
                      duration: lectures[index].duration ?? 0,
                      onTap: () {
                        setState(() {
                          selectedLectureIndex = index;
                        });
                      });
                },
              );
              ;
            });

      case CourseOptions.download:
        return Center(
          child: textInApp(
              text: 'Download Section',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        );

      case CourseOptions.certificate:
        return buildCertificateTab(
          instructorName: widget.course.instructor?.name ?? "instructor Name",
          courseTitle: widget.course.title ?? "Course Title",
        );

      case CourseOptions.more:
        return buildMoreTab();
      default:
        return Text('Invalid option ${widget.courseOption.name}');
    }
  }
}

Widget buildLectureItem(
    {required int lectureNumber,
    required String title,
    required String subtitle,
    bool isActive = false,
    required VoidCallback onTap,
    required int duration}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 3,
      color: isActive ? ColorUtility.secondary : Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: textInApp(
                    text: "Lecture $lectureNumber",
                    fontSize: 14,
                    color: isActive ? Colors.white : ColorUtility.black,
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.file_download_outlined,
                      size: 20,
                      color: isActive ? Colors.white : ColorUtility.black,
                    ))
              ],
            ),
            Flexible(
              child: textInApp(
                  text: title,
                  fontSize: 14,
                  color: isActive ? Colors.white : ColorUtility.black),
            ),
            Flexible(
              child: textInApp(
                  text: subtitle,
                  fontSize: 14,
                  color: isActive ? Colors.white : ColorUtility.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: textInApp(
                      text: "Duration $duration",
                      fontSize: 10,
                      color: isActive ? Colors.white : ColorUtility.black),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_circle_outline,
                      size: 40,
                      color: isActive ? Colors.white : ColorUtility.black,
                    ))
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildCertificateTab({
  required String instructorName,
  required String courseTitle,
}) {
  return SingleChildScrollView(
    child: Center(
      child: Container(
        width: 300.w,
        height: 400.h,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorUtility.grey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textInApp(
                text: "Certificate of Completion",
                fontSize: 22,
                fontWeight: FontWeight.bold),
            SizedBox(height: 16.h),
            textInApp(text: "This is to certify that", fontSize: 16),
            SizedBox(height: 8.h),
            textInApp(
                text: FirebaseAuth.instance.currentUser?.displayName ??
                    "Student Name",
                fontSize: 18,
                color: ColorUtility.secondary,
                fontWeight: FontWeight.bold),
            SizedBox(height: 16.h),
            textInApp(
                text: "has successfully completed the course: ", fontSize: 16),
            SizedBox(height: 10.h),
            textInApp(
                text: courseTitle, fontSize: 16, color: ColorUtility.secondary),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textInApp(text: "Instructor Name :", fontSize: 16),
                SizedBox(width: 10.w),
                textInApp(
                    text: instructorName,
                    fontSize: 16,
                    color: ColorUtility.secondary),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMoreTab() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      buildMoreItem('About Instructor'),
      buildMoreItem('Course Resources'),
      buildMoreItem('Share this Course'),
    ],
  );
}

Widget buildMoreItem(String title) {
  return Card(
    color: Colors.grey[100],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    margin: const EdgeInsets.only(bottom: 15),
    child: ExpansionTile(
      title: textInApp(text: title, fontSize: 15, fontWeight: FontWeight.w500),
      trailing: const Icon(Icons.double_arrow),
      children: [
        SizedBox(height: 12.h),
        textInApp(
            text: 'Come soon...', fontSize: 14, color: Colors.grey.shade600),
      ],
    ),
  );
}
