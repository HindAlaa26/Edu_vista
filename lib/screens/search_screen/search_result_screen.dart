import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/course_bloc/course_bloc.dart';
import '../../bloc/course_bloc/course_state.dart';
import '../../models/course_model.dart';
import '../../utils/color_utility.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchTerm;
  final Function(Course) onCourseSelected;

  const SearchResultsScreen({
    super.key,
    required this.searchTerm,
    required this.onCourseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseSearchLoading) {
            return const Center(
                child:
                    CircularProgressIndicator(color: ColorUtility.secondary));
          } else if (state is CourseSearchLoaded) {
            return ListView.builder(
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return ListTile(
                  leading: CourseImageComponent(imageUrl: course.image),
                  title: Text(course.title ?? 'No title'),
                  subtitle: Text(course.instructor?.name ?? 'No instructor'),
                  onTap: () {
                    onCourseSelected(course);
                  },
                );
              },
            );
          } else if (state is CourseSearchEmpty) {
            return const Center(child: Text('No courses found.'));
          } else if (state is CourseSearchError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Search for courses.'));
          }
        },
      ),
    );
  }
}

class CourseImageComponent extends StatelessWidget {
  final String? imageUrl;

  const CourseImageComponent({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? Image.network(imageUrl!, fit: BoxFit.cover, width: 50.w, height: 50.h)
        : Container(
            height: 50.h,
            width: 50.w,
            decoration: const BoxDecoration(
                color: ColorUtility.grey,
                borderRadius: BorderRadius.all(Radius.circular(5))),
          );
  }
}
