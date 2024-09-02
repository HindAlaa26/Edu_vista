abstract class CourseSearchEvent {}

class FetchCourses extends CourseSearchEvent {
  final String title;

  FetchCourses({required this.title});
}
