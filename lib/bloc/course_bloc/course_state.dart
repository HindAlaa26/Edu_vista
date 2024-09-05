import '../../models/course_model.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseSearchLoading extends CourseState {}

class CourseSearchEmpty extends CourseState {}

class CourseSearchLoaded extends CourseState {
  final List<Course> courses;

  CourseSearchLoaded(this.courses);
}

class CourseSearchError extends CourseState {
  final String message;

  CourseSearchError(this.message);
}

// payed courses
class CoursePayedLoading extends CourseState {}

class CoursePayedEmpty extends CourseState {}

class CoursePayedLoaded extends CourseState {
  final List<Course> courses;

  CoursePayedLoaded(this.courses);
}

class CoursePayedError extends CourseState {
  final String message;

  CoursePayedError(this.message);
}
