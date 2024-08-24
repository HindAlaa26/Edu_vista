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

        // Emit the first lecture as selected by default
        emit(LectureLoadedState(
          lectures,
          selectedLectureIndex: 0,
          selectedLectureUrl: lectures[0].lectureUrl,
        ));
      }
    } catch (e) {
      emit(LectureErrorState('Error occurred: ${e.toString()}'));
    }
  }

  void _onSelectLecture(SelectLectureEvent event, Emitter<LectureState> emit) {
    if (state is LectureLoadedState) {
      final currentState = state as LectureLoadedState;
      final selectedLectureUrl =
          currentState.lectures[event.lectureIndex].lectureUrl;

      emit(LectureLoadedState(
        currentState.lectures,
        selectedLectureIndex: event.lectureIndex,
        selectedLectureUrl: selectedLectureUrl,
      ));
    }
  }
}
