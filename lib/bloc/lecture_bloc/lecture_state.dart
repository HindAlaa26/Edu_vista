import '../../models/lecture_model.dart';

sealed class LectureState {}

final class LectureLoadingState extends LectureState {}

class LectureLoadedState extends LectureState {
  final List<Lecture> lectures;
  final int? selectedLectureIndex;
  final String? selectedLectureUrl;

  LectureLoadedState(
    this.lectures, {
    this.selectedLectureIndex,
    this.selectedLectureUrl,
  });
}

final class LectureErrorState extends LectureState {
  final String error;

  LectureErrorState(this.error);
}

final class LectureInitialState extends LectureState {}
