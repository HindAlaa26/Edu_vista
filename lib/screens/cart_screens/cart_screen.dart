import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/cart_bloc/cart_state.dart';
import '../../shared_component/cart_component/custom_cart.dart';
import '../../shared_component/default_text.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
                  child: ListView.builder(
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return CustomCartTile(
                        course: course,
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textInApp(
                            text:
                                'Total: \$${state.totalPrice.toStringAsFixed(2)}'),
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
