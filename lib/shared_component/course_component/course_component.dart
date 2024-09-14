import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/course_model.dart';
import '../../screens/lecture_screen/lecture_screen.dart';
import '../../utils/color_utility.dart';
import '../default_text.dart';
import '../rating_bar_widget.dart';

class CourseComponent extends StatefulWidget {
  final String rankValue;
  bool isSeeAll;
  CourseComponent({super.key, required this.rankValue, this.isSeeAll = false});

  @override
  State<CourseComponent> createState() => _CourseComponentState();
}

class _CourseComponentState extends State<CourseComponent> {
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

          return courseWidget(
              context: context, courses: courses, isSeeAll: widget.isSeeAll);
        });
  }
}

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
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: ColorUtility.grey),
                      ),
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
