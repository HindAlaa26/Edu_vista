import 'package:edu_vista/screens/cart_screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_vista/bloc/lecture_bloc/lecture_bloc.dart';
import 'package:edu_vista/bloc/lecture_bloc/lecture_event.dart';
import 'package:edu_vista/bloc/lecture_bloc/lecture_state.dart';
import 'package:edu_vista/models/course_model.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/cart_bloc/cart_event.dart';
import '../../shared_component/default_button_component .dart';
import '../../shared_component/default_text_component .dart';
import '../../shared_component/lecture_component/lecture_component.dart';
import '../../shared_component/video_player.dart';
import '../../utils/app_enum.dart';

class LectureScreen extends StatefulWidget {
  final Course course;

  LectureScreen({required this.course});

  @override
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String? videoID;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LectureBloc()
        ..add(LoadLecturesEvent(courseId: widget.course.id ?? "")),
      child: BlocListener<LectureBloc, LectureState>(
        listener: (context, state) {
          if (state is LectureLoadedState) {
            if (state.selectedLectureUrl != videoID) {
              setState(() {
                videoID = state.selectedLectureUrl;
                print("Video URL updated to: $videoID"); // Debug statement
              });
            }
          } else if (state is LectureErrorState) {
            print("Error: ${state.error}"); // Debug statement
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    videoID == null || videoID!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: SizedBox(
                                width: ScreenUtil().screenWidth,
                                child: textInApp(
                                    text: "No video", color: Colors.white)),
                          )
                        : VideoWidget(
                            videoUrl: videoID!,
                            key: ValueKey(videoID),
                          ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 239.h,
                      left: 0.w,
                      right: 0.w,
                      child: Container(
                        height: ScreenUtil().screenHeight,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textInApp(
                                    text: widget.course.title ?? "Course Name",
                                    color: const Color(0xff1D1B20),
                                  ),
                                  SizedBox(width: 50.w),
                                  Expanded(
                                    child: defaultButton(
                                      text: "Add To Cart",
                                      onTap: () {
                                        context.read<CartBloc>().add(
                                            AddCourseToCart(widget.course));
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: textInApp(
                                text: widget.course.instructor?.name ??
                                    "Instructor Name",
                                color: const Color(0xff1D1B20),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            TabBar(
                              controller: tabController,
                              unselectedLabelColor: ColorUtility.black,
                              indicatorColor: ColorUtility.secondary,
                              labelColor: Colors.white,
                              physics: const BouncingScrollPhysics(),
                              isScrollable: true,
                              indicatorPadding:
                                  EdgeInsets.symmetric(horizontal: -10.w),
                              indicatorWeight: 5,
                              indicator: BoxDecoration(
                                color: ColorUtility.secondary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              tabs: [
                                textInApp(text: 'Lecture', fontSize: 15),
                                textInApp(text: 'Download', fontSize: 15),
                                textInApp(text: 'Certificate', fontSize: 15),
                                textInApp(text: 'More', fontSize: 15),
                              ],
                            ),
                            SizedBox(
                              height: 600.h,
                              child: TabBarView(
                                controller: tabController,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  LecturesWidget(
                                    course: widget.course,
                                    courseOption: CourseOptions.lecture,
                                  ),
                                  LecturesWidget(
                                    course: widget.course,
                                    courseOption: CourseOptions.download,
                                  ),
                                  LecturesWidget(
                                    course: widget.course,
                                    courseOption: CourseOptions.certificate,
                                  ),
                                  LecturesWidget(
                                    course: widget.course,
                                    courseOption: CourseOptions.more,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
