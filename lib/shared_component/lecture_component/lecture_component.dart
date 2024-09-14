import 'package:edu_vista/bloc/lecture_bloc/lecture_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/lecture_bloc/lecture_bloc.dart';
import '../../bloc/lecture_bloc/lecture_state.dart';
import '../../models/course_model.dart';
import '../../utils/app_enum.dart';
import '../../utils/color_utility.dart';
import '../default_text.dart';
import '../web_view.dart';

class LecturesWidget extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;

  const LecturesWidget({
    required this.course,
    super.key,
    required this.courseOption,
  });

  @override
  State<LecturesWidget> createState() => _LecturesWidgetState();
}

class _LecturesWidgetState extends State<LecturesWidget> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    if (widget.courseOption == CourseOptions.lecture) {
      context.read<LectureBloc>().add(
            LoadLecturesEvent(
              courseId: widget.course.id ?? '',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LectureBloc, LectureState>(
      builder: (context, state) {
        if (widget.courseOption == CourseOptions.lecture) {
          if (state is LectureLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorUtility.secondary,
              ),
            );
          } else if (state is LectureLoadedState) {
            var lectures = state.lectures;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 6,
                childAspectRatio: 0.7,
              ),
              itemCount: lectures.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              addAutomaticKeepAlives: true,
              itemBuilder: (context, index) {
                return buildLectureItem(
                    title: lectures[index].title ?? "Lecture title",
                    isActive: index == state.selectedLectureIndex,
                    subtitle:
                        lectures[index].description ?? "Lecture description",
                    lectureNumber: lectures[index].sort ?? 1,
                    duration: lectures[index].duration ?? 0,
                    onTap: () {
                      context.read<LectureBloc>().add(
                            SelectLectureEvent(
                              lectureIndex: index,
                              courseId: widget.course.id ?? '',
                            ),
                          );
                    });
              },
            );
          } else if (state is LectureErrorState) {
            return Center(
              child: textInApp(text: state.error),
            );
          } else {
            return Center(
              child: textInApp(text: 'No Lectures found come soon...'),
            );
          }
        }
        if (widget.courseOption == CourseOptions.download) {
          if (state is LectureLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorUtility.secondary,
              ),
            );
          } else if (state is LectureLoadedState) {
            var lectures = state.lectures;
            return buildDownloadItem(lectures: lectures);
          } else if (state is LectureErrorState) {
            return Center(
              child: textInApp(text: state.error),
            );
          } else {
            return Center(
              child: textInApp(
                  text: 'Download Section',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            );
          }
        }

        return buildNonLectureTabs(widget.courseOption, widget.course);
      },
    );
  }
}

Widget buildNonLectureTabs(CourseOptions option, Course course) {
  switch (option) {
    case CourseOptions.certificate:
      return buildCertificateTab(
        instructorName: course.instructor?.name ?? "instructor Name",
        courseTitle: course.title ?? "Course Title",
      );

    case CourseOptions.more:
      return buildMoreTab(course: course);
    default:
      return Text('Invalid option ${option.name}');
  }
}

Widget buildLectureItem({
  required int lectureNumber,
  required String title,
  required String subtitle,
  bool isActive = false,
  required VoidCallback onTap,
  required int duration,
}) {
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: textInApp(
                      text: "Lecture $lectureNumber",
                      fontSize: 14,
                      color: isActive ? Colors.white : ColorUtility.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: textInApp(
                  text: title,
                  fontSize: 14,
                  color: isActive ? Colors.white : ColorUtility.black),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: textInApp(
                    text: subtitle,
                    fontSize: 14,
                    color: isActive ? Colors.white : ColorUtility.black),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: textInApp(
                        text: "Duration $duration seconds",
                        fontSize: 10,
                        color: isActive ? Colors.white : ColorUtility.black),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_outline,
                        size: 40,
                        color: isActive ? Colors.white : ColorUtility.black,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildDownloadItem({required lectures}) {
  return GridView.builder(
    padding: const EdgeInsets.all(10),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 9,
      crossAxisSpacing: 7,
      childAspectRatio: 1,
    ),
    itemCount: lectures.length,
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    addAutomaticKeepAlives: true,
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowWebView(
                  lectureNumber: lectures[index].sort!,
                  url: lectures[index].lectureMaterial!,
                ),
              ));
        },
        child: Container(
          height: 100.h,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorUtility.secondary,
              gradient: const LinearGradient(colors: [
                ColorUtility.secondary,
                Colors.brown,
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              textInApp(
                  text: 'Lecture ${lectures[index].sort}',
                  color: Colors.white,
                  fontSize: 15),
              SizedBox(
                height: 20.h,
              ),
              textInApp(
                  text: lectures[index].title ?? "Lecture title",
                  color: Colors.white,
                  fontSize: 14),
            ],
          ),
        ),
      );
    },
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
          child: Stack(children: [
            Positioned(
              right: 0,
              top: 0,
              child: Image.asset(
                "assets/images/certificate_circle.png",
                fit: BoxFit.cover,
              ),
            ),
            Column(
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
                    text: "has successfully completed the course: ",
                    fontSize: 16),
                SizedBox(height: 10.h),
                textInApp(
                    text: courseTitle,
                    fontSize: 16,
                    color: ColorUtility.secondary),
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
          ])),
    ),
  );
}

Widget buildMoreTab({required Course course}) {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      buildMoreItem(course: course),
    ],
  );
}

Widget buildMoreItem({required Course course}) {
  return Card(
    color: Colors.grey[100],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    margin: const EdgeInsets.only(bottom: 15),
    child: ExpansionTile(
      title: textInApp(
          text: "About Instructor", fontSize: 15, fontWeight: FontWeight.w500),
      trailing: const Icon(Icons.double_arrow),
      children: [
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textInApp(
                  text: 'Instructor Name:',
                  fontSize: 14,
                  color: ColorUtility.main),
              Padding(
                padding: EdgeInsets.only(right: 80.w),
                child: textInApp(
                  text: '${course.instructor?.name}',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textInApp(
                  text: 'Instructor graduation From :',
                  fontSize: 14,
                  color: ColorUtility.main),
              Expanded(
                child: textInApp(
                  text: '${course.instructor?.graduationFrom}',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textInApp(
                  text: 'Instructor year Of Experience :',
                  fontSize: 14,
                  color: ColorUtility.main),
              Expanded(
                child: textInApp(
                  text: '${course.instructor?.yearOfExperience}',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    ),
  );
}
