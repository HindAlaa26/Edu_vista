import 'package:edu_vista/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc/cart_bloc.dart';
import '../bloc/cart_bloc/cart_state.dart';
import '../shared_component/custom_cart_component.dart';
import '../shared_component/default_text_component .dart';
import '../utils/color_utility.dart';

class CheckOutScreen extends StatelessWidget {
  final Course course;
  const CheckOutScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textInApp(text: 'Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorUtility.secondary,
            ));
          } else if (state is CartLoaded) {
            if (state.courses.isEmpty) {
              return Center(child: textInApp(text: 'Cart is empty'));
            }

            return Column(
              children: [
                Expanded(
                    child: CustomCartTile(
                  course: course,
                  isCheckOutScreen: true,
                )),
                Container(
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textInApp(
                            text:
                                'Total: \$${course.price?.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(child: textInApp(text: state.message));
          }
          return Container();
        },
      ),
    );
  }
}
