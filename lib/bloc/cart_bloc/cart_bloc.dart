import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';
import '../../models/course_model.dart';
import '../../screens/course_screens/courses_screen.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  List<Course> _courses = [];

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddCourseToCart>(_onAddCourseToCart);
    on<CheckoutCart>(_onCheckoutCart);
    on<RemoveCourseFromCart>(_onRemoveFromCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final snapshot = await _fireStore
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
    await _saveCartToFireStore();
  }

  Future<void> _onCheckoutCart(
      CheckoutCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      PaymobPayment.instance.initialize(
        apiKey: dotenv.env['apiKey']!,
        integrationID: int.parse(dotenv.env['integrationID']!),
        iFrameID: int.parse(dotenv.env['iFrameID']!),
      );

      final PaymobResponse? response = await PaymobPayment.instance.pay(
        context: event.context,
        currency: "EGP",
        amountInCents:
            "${(event.course.price! * 30).toInt()}",
      );

      if (response != null && response.success) {
        final payedCoursesRef = _fireStore
            .collection('users')
            .doc(userId)
            .collection('payed_courses');
        final cartRef =
            _fireStore.collection('users').doc(userId).collection('cart');

        // Add the course to payed_courses
        final payedDocRef = payedCoursesRef.doc(event.course.id);
        await payedDocRef.set(event.course.toJson());

        // Remove the course from cart
        final cartDocRef = cartRef.doc(event.course.id);
        await cartDocRef.delete();

        // Remove the course from the local list
        _courses.remove(event.course);

        // Emit the updated state
        emit(CartLoaded(_courses, _calculateTotalPrice()));

        if (!event.context.mounted) return;
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => const CoursesScreen(),
          ),
        );

        print('Payment Successful: ${response.transactionID}');
      } else {
        emit(CartError('Payment was unsuccessful.'));
      }
    } catch (e) {
      emit(CartError('Checkout failed: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveCourseFromCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      _courses.remove(event.course);

      final cartRef =
          _fireStore.collection('users').doc(userId).collection('cart');
      final docRef = cartRef.doc(event.course.id);
      await docRef.delete();

      emit(CartLoaded(_courses, _calculateTotalPrice()));
    } catch (e) {
      emit(CartError('Checkout failed: ${e.toString()}'));
    }
  }

  Future<void> _saveCartToFireStore() async {
    final cartRef =
        _fireStore.collection('users').doc(userId).collection('cart');
    final batch = _fireStore.batch();

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
