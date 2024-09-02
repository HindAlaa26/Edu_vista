import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/course_model.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseSearchBloc extends Bloc<CourseSearchEvent, CourseSearchState> {
  CourseSearchBloc() : super(CourseSearchInitial()) {
    on<FetchCourses>(_onFetchCourses);
  }

  Future<void> _onFetchCourses(
      FetchCourses event, Emitter<CourseSearchState> emit) async {
    final searchTerm = event.title.trim().toLowerCase();

    if (searchTerm.isEmpty) {
      emit(CourseSearchInitial());
      return;
    }

    emit(CourseSearchLoading());
    try {
      final fetchCourses =
          await FirebaseFirestore.instance.collection("courses").get();

      final courses = fetchCourses.docs
          .map((doc) => Course.fromJson({'id': doc.id, ...doc.data()}))
          .where((course) {
        final courseTitle = course.title?.toLowerCase() ?? "";
        return courseTitle.contains(searchTerm);
      }).toList();

      if (courses.isEmpty) {
        emit(CourseSearchEmpty());
      } else {
        emit(CourseSearchLoaded(courses));
      }
    } catch (e) {
      emit(CourseSearchError(e.toString()));
    }
  }
}
