class UserModel {
  String? name;
  String? email;
  String? uid;
  String? image;

  UserModel({
    this.name,
    this.email,
    this.uid,
    this.image,
  });

  UserModel.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    email = data['email'];
    uid = data['uid'];
    image = data['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'image': image,
    };
  }
}
