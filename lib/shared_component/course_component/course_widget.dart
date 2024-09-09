import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/course_model.dart';
import '../../screens/lecture_screen/lecture_screen.dart';
import '../../utils/color_utility.dart';
import '../default_text_component .dart';
import '../rating_bar_widget.dart';

Widget courseWidget({
  required BuildContext context,
  required List<Course> courses,
  bool isSeeAll = false,
}) {
  return GridView.count(
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(isSeeAll ? courses.length : 2, (index) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Stack(
                    children: [
                      // when NetworkImage fails
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: ColorUtility.grey),
                      ),
                      // when NetworkImage loads
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          image: DecorationImage(
                            image: NetworkImage(courses[index].image ?? ""),
                            fit: BoxFit.fill,
                            onError: (exception, stackTrace) {
                              print('Error loading image: $exception');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  textInApp(
                      text: "${courses[index].rating}",
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                  SizedBox(
                    width: 8.w,
                  ),
                  ratingBarWidget(value: courses[index].rating!)
                ],
              ),
              Flexible(
                flex: 3,
                child: textInApp(
                    text: courses[index].title ?? 'No Name',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
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
        );
      }));
}
