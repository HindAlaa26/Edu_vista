import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category_model.dart';
import 'package:edu_vista/models/instructor_model.dart';

class Course {
  String? id;
  String? title;
  String? image;
  Category? category;
  String? currency;
  String? rank;
  bool? hasCertificate;
  Instructor? instructor;
  double? price;
  double? rating;
  int? totalHours;
  DateTime? createdDate;

  Course.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    image = data['image'];
    category =
        data['category'] != null ? Category.fromJson(data['category']) : null;
    currency = data['currency'];
    rank = data['rank'];
    hasCertificate = data['hasCertificate'];
    instructor = data['instructor'] != null
        ? Instructor.fromJson(data['instructor'])
        : null;
    price = data['price'] is int
        ? (data['price'] as int).toDouble()
        : data['price'];
    rating = data['rating'] is int
        ? (data['rating'] as int).toDouble()
        : data['rating'];
    totalHours = data['totalHours'];
    createdDate = data['createdDate'] != null
        ? (data['createdDate'] as Timestamp).toDate()
        : null;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'category': category?.toJson(),
      'currency': currency,
      'rank': rank,
      'hasCertificate': hasCertificate,
      'instructor': instructor?.toJson(),
      'price': price,
      'rating': rating,
      'totalHours': totalHours,
      'createdDate':
          createdDate != null ? Timestamp.fromDate(createdDate!) : null,
    };
  }
}
