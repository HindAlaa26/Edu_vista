import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/lecture_model.dart';
import 'lecture_event.dart';
import 'lecture_state.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  LectureBloc() : super(LectureInitialState()) {
    on<LoadLecturesEvent>(_onLoadLectures);
    on<SelectLectureEvent>(_onSelectLecture);
  }

  Future<String?> _getUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _onLoadLectures(
      LoadLecturesEvent event, Emitter<LectureState> emit) async {
    emit(LectureLoadingState());
    try {
      final lecturesSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(event.courseId)
          .collection('lectures')
          .orderBy("sort")
          .get();

      if (lecturesSnapshot.docs.isEmpty) {
        emit(LectureErrorState('No Lectures found'));
      } else {
        final lectures = lecturesSnapshot.docs
            .map((doc) => Lecture.fromJson({'id': doc.id, ...doc.data()}))
            .toList();

        final lastWatchedLectureId = await _getLastWatchedLectureId();
        final lastWatchedLectureIndex = lastWatchedLectureId != null
            ? lectures
                .indexWhere((lecture) => lecture.id == lastWatchedLectureId)
            : 0;

        emit(LectureLoadedState(
          lectures,
          selectedLectureIndex: lastWatchedLectureIndex,
          selectedLectureUrl: lectures.isNotEmpty
              ? lectures[lastWatchedLectureIndex].lectureUrl
              : null,
        ));
      }
    } catch (e) {
      emit(LectureErrorState('Error occurred: ${e.toString()}'));
    }
  }

  void _onSelectLecture(
      SelectLectureEvent event, Emitter<LectureState> emit) async {
    if (state is LectureLoadedState) {
      final currentState = state as LectureLoadedState;
      final selectedLecture = currentState.lectures[event.lectureIndex];
      final selectedLectureUrl = selectedLecture.lectureUrl;

      if (selectedLecture.id != null) {
        await _saveLastWatchedLecture(selectedLecture.id!);
      }

      emit(LectureLoadedState(
        currentState.lectures,
        selectedLectureIndex: event.lectureIndex,
        selectedLectureUrl: selectedLectureUrl,
      ));
    }
  }

  Future<void> _saveLastWatchedLecture(String lectureId) async {
    final userId = await _getUserId();
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('last_watched_lecture')
          .doc(userId)
          .set({
        'last_watched_lecture_id': lectureId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving last watched lecture: ${e.toString()}');
    }
  }

  Future<String?> _getLastWatchedLectureId() async {
    final userId = await _getUserId();
    if (userId == null) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('last_watched_lecture')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()?['last_watched_lecture_id'] as String?;
      }
      return null;
    } catch (e) {
      print('Error retrieving last watched lecture: ${e.toString()}');
      return null;
    }
  }
}
