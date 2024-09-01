import '../../models/course_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Course> courses;
  final double totalPrice;

  CartLoaded(this.courses, this.totalPrice);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
