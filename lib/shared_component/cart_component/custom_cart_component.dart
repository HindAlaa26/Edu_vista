import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:edu_vista/screens/cart_screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/cart_bloc/cart_event.dart';
import '../../models/course_model.dart';
import '../../screens/cart_screens/check_out_screen.dart';
import '../../screens/lecture_screen/lecture_screen.dart';
import '../../utils/color_utility.dart';
import '../default_button_component .dart';
import '../default_text_component .dart';

class CustomCartTile extends StatefulWidget {
  final Course course;
  final bool isCheckOutScreen;
  const CustomCartTile({
    super.key,
    required this.course,
    this.isCheckOutScreen = false,
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
                                        filledColor: ColorUtility.main,
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
                            text: widget.isCheckOutScreen ? "Remove" : "Cancel",
                            onTap: () {
                              widget.isCheckOutScreen
                                  ? (context
                                      .read<CartBloc>()
                                      .add(CheckoutCart(widget.course)))
                                  : (setState(() {
                                      checkCard = false;
                                    }));
                            }),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: defaultButton(
                            text: widget.isCheckOutScreen
                                ? "Checkout"
                                : "Buy Now",
                            onTap: () {
                              widget.isCheckOutScreen
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentScreen(),
                                      ))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckOutScreen(
                                          course: widget.course,
                                        ),
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
