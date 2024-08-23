import 'package:edu_vista/screens/lecture_screen.dart';
import 'package:edu_vista/shared_component/default_text_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/course_model.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';

class CourseWidget extends StatefulWidget {
  final String rankValue;
  const CourseWidget({super.key, required this.rankValue});

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rankValue)
        .orderBy('createdDate', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureCall,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          }

          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return const Center(
              child: Text('No categories found'),
            );
          }

          var courses = List<Course>.from(snapshot.data?.docs
                  .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          return SizedBox(
              height: 280.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(courses.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LectureScreen(
                              course: courses[index],
                            ),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150.h,
                            width: 180.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        courses[index].image ?? ""),
                                    fit: BoxFit.fill)),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textInApp(
                                  text: "${courses[index].rating}",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                              SizedBox(
                                width: 8.w,
                              ),
                              AnimatedRatingStars(
                                initialRating: courses[index].rating!,
                                filledColor: ColorUtility.secondary,
                                emptyColor: ColorUtility.grey,
                                onChanged: (double rating) {
                                  print('Rating: $rating');
                                },
                                customFilledIcon: Icons.star,
                                customHalfFilledIcon: Icons.star_half,
                                customEmptyIcon: Icons.star_border,
                                starSize: 11.0,
                                readOnly: true,
                              )
                            ],
                          ),
                          textInApp(
                              text: courses[index].title ?? 'No Name',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 13,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              textInApp(
                                  text: "${courses[index].instructor?.name}",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                          textInApp(
                              text: "\$ ${courses[index].price}",
                              fontSize: 17.5.sp,
                              fontWeight: FontWeight.w800,
                              color: ColorUtility.main),
                        ],
                      ),
                    ),
                  );
                }),
              ));
        });
  }
}
