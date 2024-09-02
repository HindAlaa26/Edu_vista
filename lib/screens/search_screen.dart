import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/course_model.dart';
import '../bloc/course_bloc/course_bloc.dart';
import '../bloc/course_bloc/course_event.dart';
import '../bloc/course_bloc/course_state.dart';
import '../shared_component/course_title_component.dart';
import '../shared_component/default_text_component .dart';
import '../shared_component/shopping_icon_widget.dart';
import 'lecture_screen.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xffffffff),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              BlocProvider.of<CourseSearchBloc>(context).add(
                FetchCourses(
                  title: value.trim(),
                ),
              );
            },
            decoration: InputDecoration(
              hintText: "Search by course title...",
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {
                  BlocProvider.of<CourseSearchBloc>(context).add(
                    FetchCourses(
                      title: searchController.text.trim(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        actions: [shoppingIcon()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CourseSearchBloc, CourseSearchState>(
                builder: (context, state) {
                  if (state is CourseSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CourseSearchLoaded) {
                    return _buildCourseList(state.courses);
                  } else if (state is CourseSearchEmpty) {
                    return Center(child: textInApp(text: "No courses found."));
                  } else if (state is CourseSearchError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textInApp(text: "Trending", fontSize: 18),
                            ],
                          ),
                        ),
                        const CourseTitleComponent(rankValue: "Top Sellers")
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return ListTile(
          title: textInApp(text: course.title ?? "No Title"),
          subtitle: textInApp(text: course.instructor?.name ?? "No Instructor"),
          leading: Image.network(
            course.image ?? "",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const CircularProgressIndicator(
                color: ColorUtility.secondary,
              );
            },
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.error,
              color: ColorUtility.main,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LectureScreen(
                    course: courses[index],
                  ),
                ));
          },
        );
      },
    );
  }
}
