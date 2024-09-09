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

// Based on Your Search courses
class BasedOnYourSearchLoading extends CourseState {}

class BasedOnYourSearchLoaded extends CourseState {
  final List<Course> courses;
  BasedOnYourSearchLoaded(this.courses);
}

class BasedOnYourSearchEmpty extends CourseState {}

class BasedOnYourSearchError extends CourseState {
  final String message;
  BasedOnYourSearchError(this.message);
}

// Payed courses
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
