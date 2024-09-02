import '../../models/course_model.dart';

abstract class CourseSearchState {}

class CourseSearchInitial extends CourseSearchState {}

class CourseSearchLoading extends CourseSearchState {}

class CourseSearchEmpty extends CourseSearchState {}

class CourseSearchLoaded extends CourseSearchState {
  final List<Course> courses;

  CourseSearchLoaded(this.courses);
}

class CourseSearchError extends CourseSearchState {
  final String message;

  CourseSearchError(this.message);
}
