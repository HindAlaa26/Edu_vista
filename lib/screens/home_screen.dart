import 'package:edu_vista/bloc/cart_bloc/cart_bloc.dart';
import 'package:edu_vista/bloc/cart_bloc/cart_state.dart';
import 'package:edu_vista/screens/cart_screen.dart';
import 'package:edu_vista/screens/see_all_courses_screen.dart';
import 'package:edu_vista/shared_component/default_text_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared_component/category_widget.dart';
import '../shared_component/course_component.dart';
import '../shared_component/home_label_shared_component.dart';
import 'see_all_category_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<String> coursesHeadlines = [
    "Students Also Search for",
    "Top Courses in IT",
    "Top Sellers"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            textInApp(text: "Welcome"),
            SizedBox(width: 8.w),
            textInApp(
                text: "${FirebaseAuth.instance.currentUser?.displayName}",
                color: ColorUtility.main),
          ],
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                // Show a loading indicator while cart data is being fetched
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartLoaded) {
                // Display the shopping cart icon with item count badge
                final cartItemCount = state.courses.length;
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        // Navigate to the cart screen
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
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                );
              } else if (state is CartError) {
                // Show the cart icon and optionally handle errors
                return IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    // Optionally show an error dialog or a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  },
                );
              }

              // Default case when the cart is empty or initial state
              return IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              LabelWidget(
                name: 'Categories',
                onSeeAllClicked: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeeAllCategoryScreen(),
                      ));
                },
              ),
              const CategoriesWidget(),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => Column(
                          children: [
                            LabelWidget(
                              name: coursesHeadlines[index],
                              onSeeAllClicked: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeeAllCoursesScreen(
                                          rankValue: coursesHeadlines[index]),
                                    ));
                              },
                            ),
                            CourseComponent(
                              rankValue: coursesHeadlines[index],
                            ),
                          ],
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10.h,
                        ),
                    itemCount: coursesHeadlines.length),
              )
            ],
          ),
        ),
      ),
    );
  }
}
