import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:edu_vista/shared_component/default_button_component%20.dart';
import 'package:edu_vista/shared_component/default_text_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/cart_bloc/cart_bloc.dart';
import '../bloc/cart_bloc/cart_event.dart';
import '../bloc/cart_bloc/cart_state.dart';
import '../models/course_model.dart';
import 'check_out_screen.dart';
import 'lecture_screen.dart';

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

class CustomCartTile extends StatefulWidget {
  final Course course;

  const CustomCartTile({
    super.key,
    required this.course,
  });

  @override
  State<CustomCartTile> createState() => _CustomCartTileState();
}

class _CustomCartTileState extends State<CustomCartTile> {
  bool checkCard = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 15.w),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtility.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LectureScreen(
                                course: widget.course,
                              ),
                            ));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                image: DecorationImage(
                                  image:
                                      NetworkImage(widget.course.image ?? ""),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    print('Error loading image: $exception');
                                  },
                                ),
                              ),
                              height: 150.h,
                              width: 150.w,
                            ),
                          ),
                          SizedBox(width: 18.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textInApp(
                                    text: widget.course.title ?? 'No Name',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 13,
                                    ),
                                    SizedBox(width: 10.w),
                                    textInApp(
                                        text:
                                            "${widget.course.instructor?.name}",
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    textInApp(
                                        text: "${widget.course.rating}",
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: AnimatedRatingStars(
                                        initialRating: widget.course.rating!,
                                        filledColor: ColorUtility.secondary,
                                        emptyColor: ColorUtility.grey,
                                        onChanged: (double rating) {
                                          print('Rating: $rating');
                                        },
                                        customFilledIcon: Icons.star,
                                        customHalfFilledIcon: Icons.star_half,
                                        customEmptyIcon: Icons.star_border,
                                        starSize: 10.0,
                                        readOnly: true,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                textInApp(
                                    text: "\$${widget.course.price}",
                                    fontSize: 17.5.sp,
                                    fontWeight: FontWeight.w800,
                                    color: ColorUtility.main),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 50,
                  color:
                      checkCard ? ColorUtility.secondary : ColorUtility.black,
                ),
                onPressed: () {
                  setState(() {
                    checkCard = !checkCard;
                  });
                },
              ),
            ],
          ),
          checkCard
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: 16, bottom: 16, left: 115),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: defaultButton(
                            color: ColorUtility.grey,
                            textColor: Colors.black,
                            text: "Cancel",
                            onTap: () {
                              context
                                  .read<CartBloc>()
                                  .add(RemoveCourseFromCart(widget.course));
                            }),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: defaultButton(
                            text: "Buy Now",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckOutScreen(),
                                  ));
                            }),
                      ),
                    ],
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
