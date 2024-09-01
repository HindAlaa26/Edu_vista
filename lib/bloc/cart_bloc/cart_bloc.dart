import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/course_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  List<Course> _courses = [];

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddCourseToCart>(_onAddCourseToCart);
    on<RemoveCourseFromCart>(_onRemoveCourseFromCart);
    on<CheckoutCart>(_onCheckoutCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();
      _courses =
          snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList();
      emit(CartLoaded(_courses, _calculateTotalPrice()));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddCourseToCart(
      AddCourseToCart event, Emitter<CartState> emit) async {
    _courses.add(event.course);
    emit(CartLoaded(_courses, _calculateTotalPrice()));
    await _saveCartToFirestore();
  }

  Future<void> _onRemoveCourseFromCart(
      RemoveCourseFromCart event, Emitter<CartState> emit) async {
    _courses.remove(event.course);
    emit(CartLoaded(_courses, _calculateTotalPrice()));
    await _saveCartToFirestore();
  }

  Future<void> _onCheckoutCart(
      CheckoutCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      _courses.clear();
      emit(CartLoaded(_courses, 0.0));
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      emit(CartError('Checkout failed: ${e.toString()}'));
    }
  }

  Future<void> _saveCartToFirestore() async {
    final cartRef =
        _firestore.collection('users').doc(userId).collection('cart');
    final batch = _firestore.batch();

    for (var course in _courses) {
      final docRef = cartRef.doc(course.id);
      batch.set(docRef, course.toJson());
    }

    try {
      await batch.commit();
    } catch (e) {
      print('Failed to save cart: ${e.toString()}');
    }
  }

  double _calculateTotalPrice() {
    return _courses.fold(
        0.0, (total, course) => total + (course.price)!.toDouble());
  }
}
