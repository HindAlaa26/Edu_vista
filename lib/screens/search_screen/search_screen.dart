import 'package:edu_vista/screens/search_screen/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/course_model.dart';
import '../../bloc/course_bloc/course_bloc.dart';
import '../../bloc/course_bloc/course_event.dart';
import '../../bloc/course_bloc/course_state.dart';
import '../../shared_component/course_component/course_title_component.dart';
import '../../shared_component/default_text_component .dart';
import '../../shared_component/shopping_icon_widget.dart';
import '../lecture_screen/lecture_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String? searchTerm;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CourseBloc>(context).add(FetchBasedOnYourSearchCourses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchTerm = value.trim();
                isSearching = value.isNotEmpty;
              });
              if (value.isNotEmpty) {
                BlocProvider.of<CourseBloc>(context)
                    .add(FetchCourses(title: value.trim()));
              } else {
                BlocProvider.of<CourseBloc>(context)
                    .add(FetchBasedOnYourSearchCourses());
              }
            },
            decoration: const InputDecoration(
              hintText: "Search by course title...",
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: ColorUtility.grey),
            ),
          ),
        ),
        actions: [shoppingIcon()],
      ),
      body: isSearching
          ? SearchResultsScreen(
              searchTerm: searchTerm!,
              onCourseSelected: (course) {
                print('Selected Course: ${course.title}');
                BlocProvider.of<CourseBloc>(context)
                    .add(SaveSearchedCourse(course));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LectureScreen(course: course),
                    )).then((_) {
                  setState(() {
                    isSearching = false;
                    searchController.clear();
                    BlocProvider.of<CourseBloc>(context)
                        .add(FetchBasedOnYourSearchCourses());
                  });
                });
              },
            )
          : defaultScreen(),
    );
  }

  Widget defaultScreen() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textInApp(
            text: "Trending",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state is CourseSearchLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: ColorUtility.secondary));
              } else if (state is CourseSearchLoaded) {
                return SizedBox(
                  height: 100.h,
                  child: _buildCourseList(state.courses, context),
                );
              } else if (state is CourseSearchEmpty) {
                return Center(child: textInApp(text: "No courses found."));
              } else if (state is CourseSearchError) {
                return Center(
                    child: textInApp(text: "Error: ${state.message}"));
              } else {
                return const CourseTitleComponent(rankValue: "Top Sellers");
              }
            },
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: textInApp(
              text: "Based on Your Search",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state is BasedOnYourSearchLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: ColorUtility.secondary));
              } else if (state is BasedOnYourSearchLoaded) {
                return SizedBox(
                  height: 400.h,
                  child: _buildCourseList(state.courses, context),
                );
              } else if (state is BasedOnYourSearchEmpty) {
                return Container();
              } else if (state is BasedOnYourSearchError) {
                return Center(
                    child: textInApp(text: "Error: ${state.message}"));
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 115,
      ),
      itemCount: courses.length,
      itemBuilder: (BuildContext context, int index) {
        final course = courses[index];
        return InkWell(
          onTap: () {
            print('Navigating to LectureScreen with Course: ${course.title}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LectureScreen(course: course),
              ),
            ).then((_) {
              setState(() {
                BlocProvider.of<CourseBloc>(context)
                    .add(FetchBasedOnYourSearchCourses());
              });
            }).catchError((error) {
              print('Navigation Error: $error');
            });
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: ColorUtility.grey,
              borderRadius: BorderRadius.all(Radius.circular(42)),
            ),
            child: Center(
              child: textInApp(
                text: course.title ?? "No title",
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
