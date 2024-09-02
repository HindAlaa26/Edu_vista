import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/course_model.dart';
import '../bloc/course_bloc/course_bloc.dart';
import '../bloc/course_bloc/course_event.dart';
import '../bloc/course_bloc/course_state.dart';
import '../shared_component/default_text_component .dart';
import '../shared_component/shopping_icon_widget.dart';

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
                    return Container();
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
          title: Text(course.title ?? "No Title"),
          subtitle: Text(course.instructor?.name ?? "No Instructor"),
          leading: Image.network(
            course.image ?? "",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          onTap: () {
            // Handle course item tap, e.g., navigate to course details
          },
        );
      },
    );
  }
}
