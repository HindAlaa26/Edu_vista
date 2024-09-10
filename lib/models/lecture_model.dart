class Lecture {
  String? id;
  String? title;
  String? description;
  int? duration;
  String? lectureUrl;
  String? lectureMaterial;
  int? sort;
  List<String>? watchedUsers;

  Lecture.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    duration = data['duration'];
    lectureUrl = data['lectureUrl'];
    sort = data['sort'];
    lectureMaterial = data['lectureMaterial'];
    watchedUsers =
        data['watchedUsers'] != null ? List.from(data['watchedUsers']) : null;
  }
}
