import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc/cart_bloc.dart';
import '../bloc/cart_bloc/cart_state.dart';
import '../screens/cart_screens/cart_screen.dart';

Widget shoppingIcon() {
  return BlocBuilder<CartBloc, CartState>(
    builder: (context, state) {
      if (state is CartLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is CartLoaded) {
        final cartItemCount = state.courses.length;
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    cartItemCount.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      } else if (state is CartError) {
        return IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          },
        );
      }

      return IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CartScreen(),
            ),
          );
        },
      );
    },
  );
}
