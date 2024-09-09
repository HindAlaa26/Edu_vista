import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/color_utility.dart';

Widget ratingBarWidget({
  required double value,
}) {
  return RatingBar.builder(
    initialRating: value,
    minRating: 0,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 1.0.w),
    itemBuilder: (context, _) => const Icon(
      Icons.star,
      color: ColorUtility.main,
    ),
    itemSize: 12,
    onRatingUpdate: (rating) {
      print(rating);
    },
  );
}
