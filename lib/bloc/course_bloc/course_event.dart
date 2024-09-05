abstract class CourseEvent {}

class FetchCourses extends CourseEvent {
  final String title;

  FetchCourses({required this.title});
}

class FetchPayedCourses extends CourseEvent {
  FetchPayedCourses();
}
