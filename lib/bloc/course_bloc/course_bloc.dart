// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../models/course_model.dart';
// import '../../models/lecture_model.dart';
// import '../../utils/app_enum.dart';
// import 'course_event.dart';
// import 'course_state.dart';
//
// class CourseBloc extends Bloc<CourseEvent, CourseState> {
//   CourseBloc() : super(CourseInitial()) {
//     on<CourseFetchEvent>(_onGetCourse);
//     on<CourseOptionChosenEvent>(_onCourseOptionChosen);
//   }
//   Course? course;
//
//   Future<List<Lecture>?> getLectures() async {
//     if (course == null) {
//       return null;
//     }
//     try {
//       var result = await FirebaseFirestore.instance
//           .collection('courses')
//           .doc(course!.id)
//           .collection('lectures')
//           .get();
//
//       return result.docs
//           .map((e) => Lecture.fromJson({
//                 'id': e.id,
//                 ...e.data(),
//               }))
//           .toList();
//     } catch (e) {
//       return null;
//     }
//   }
//
//   FutureOr<void> _onGetCourse(
//       CourseFetchEvent event, Emitter<CourseState> emit) async {
//     if (course != null) {
//       course = null;
//     }
//     course = event.course;
//     emit(CourseOptionStateChanges(CourseOptions.lecture));
//   }
//
//   FutureOr<void> _onCourseOptionChosen(
//       CourseOptionChosenEvent event, Emitter<CourseState> emit) {
//     emit(CourseOptionStateChanges(event.courseOptions));
//   }
// }
