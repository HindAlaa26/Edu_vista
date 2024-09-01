class Instructor {
  String? id;
  String? name;
  String? graduationFrom;
  int? yearOfExperience;
  Instructor.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    graduationFrom = data['graduationFrom'];
    yearOfExperience = data['yearOfExperience'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'graduationFrom': graduationFrom,
      'yearOfExperience': yearOfExperience,
    };
  }
}
