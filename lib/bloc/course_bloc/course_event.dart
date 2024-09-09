import '../../models/course_model.dart';

abstract class CourseEvent {}

class FetchCourses extends CourseEvent {
  final String title;
  FetchCourses({required this.title});
}

class FetchPayedCourses extends CourseEvent {
  FetchPayedCourses();
}

class SaveSearchedCourse extends CourseEvent {
  final Course course;
  SaveSearchedCourse(this.course);
}

class FetchBasedOnYourSearchCourses extends CourseEvent {
  FetchBasedOnYourSearchCourses();
}
