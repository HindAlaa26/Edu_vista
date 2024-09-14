import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/course_bloc/course_bloc.dart';
import '../../bloc/course_bloc/course_event.dart';
import '../../bloc/course_bloc/course_state.dart';
import '../../models/course_model.dart';
import '../../shared_component/default_text.dart';
import '../../shared_component/shopping_icon_widget.dart';
import '../lecture_screen/lecture_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: textInApp(text: "Courses"),
        actions: [shoppingIcon()],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: ColorUtility.grey,
                  ),
                  child: textInApp(
                      text: "All", fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          BlocProvider(
            create: (context) {
              final courseBloc = CourseBloc();
              courseBloc.add(FetchPayedCourses());
              return courseBloc;
            },
            child: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, state) {
                if (state is CoursePayedLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: ColorUtility.secondary,
                  ));
                } else if (state is CoursePayedLoaded) {
                  return _buildCourseList(state.courses);
                } else if (state is CoursePayedEmpty) {
                  return Center(child: Image.asset("assets/images/Frame.png"));
                } else if (state is CoursePayedError) {
                  return Center(
                      child: textInApp(text: "Error: ${state.message}"));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses) {
    return Expanded(
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LectureScreen(
                      course: courses[index],
                    ),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  course.image == null
                      ? Container(
                          height: 105.23.h,
                          width: 157.84.w,
                          decoration: const BoxDecoration(
                              color: ColorUtility.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            course.image ?? "",
                            width: 157.84.w,
                            height: 105.23.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator(
                                color: ColorUtility.secondary,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.error,
                              color: ColorUtility.main,
                            ),
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textInApp(
                              text: course.title ?? "No Title",
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.perm_identity_sharp),
                              textInApp(
                                  text: course.instructor?.name ??
                                      "No Instructor",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          textInApp(
                              text: "Start your course",
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
