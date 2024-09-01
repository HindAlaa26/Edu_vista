import '../../models/course_model.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddCourseToCart extends CartEvent {
  final Course course;

  AddCourseToCart(this.course);
}

class RemoveCourseFromCart extends CartEvent {
  final Course course;

  RemoveCourseFromCart(this.course);
}

class CheckoutCart extends CartEvent {}
