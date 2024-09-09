import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/course_model.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<FetchCourses>(_onFetchSearchedCourses);
    on<FetchPayedCourses>(_onFetchPayedCourses);
    on<SaveSearchedCourse>(_onSaveSearchedCourse);
    on<FetchBasedOnYourSearchCourses>(_onFetchBasedOnYourSearchCourses);
  }

  Future<void> _onFetchSearchedCourses(
      FetchCourses event, Emitter<CourseState> emit) async {
    final searchTerm = event.title.trim().toLowerCase();

    if (searchTerm.isEmpty) {
      emit(CourseInitial());
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

  Future<void> _onSaveSearchedCourse(
      SaveSearchedCourse event, Emitter<CourseState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("searched_courses")
          .doc(event.course.id)
          .set(event.course.toJson());
    } catch (e) {
      print("Save Searched Course error ${e.toString()}");
    }
  }

  Future<void> _onFetchBasedOnYourSearchCourses(
      FetchBasedOnYourSearchCourses event, Emitter<CourseState> emit) async {
    emit(BasedOnYourSearchLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final fetchCourses = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("searched_courses")
          .get();

      final courses = fetchCourses.docs
          .map((doc) => Course.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      if (courses.isEmpty) {
        emit(BasedOnYourSearchEmpty());
      } else {
        emit(BasedOnYourSearchLoaded(courses));
      }
    } catch (e) {
      emit(BasedOnYourSearchError(e.toString()));
    }
  }

  Future<void> _onFetchPayedCourses(
      FetchPayedCourses event, Emitter<CourseState> emit) async {
    emit(CoursePayedLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final fetchCourses = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("payed_courses")
          .get();

      final courses = fetchCourses.docs
          .map((doc) => Course.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      if (courses.isEmpty) {
        emit(CoursePayedEmpty());
      } else {
        emit(CoursePayedLoaded(courses));
      }
    } catch (e) {
      emit(CoursePayedError(e.toString()));
    }
  }
}
