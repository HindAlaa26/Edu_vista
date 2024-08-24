sealed class LectureEvent {}

final class LoadLecturesEvent extends LectureEvent {
  final String courseId;

  LoadLecturesEvent({required this.courseId});
}

final class SelectLectureEvent extends LectureEvent {
  final int lectureIndex;

  SelectLectureEvent({required this.lectureIndex});
}
