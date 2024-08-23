import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/course_model.dart';
import '../shared_component/lecture_component.dart';
import '../utils/app_enum.dart';
import '../utils/color_utility.dart';
import '../shared_component/default_text_component .dart';

class LectureScreen extends StatefulWidget {
  final Course course;

  LectureScreen({required this.course});

  @override
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final videoUrl = "https://youtu.be/YMx8Bbev6T4?si=reH3n_KYzM6eFznU";
  late YoutubePlayerController _videoPlayerController;
  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoUrl);
    _videoPlayerController = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }
  void dispose() {
    _videoPlayerController.dispose();
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Stack(
                  children: [
                    YoutubePlayer(
                      controller: _videoPlayerController,
                      showVideoProgressIndicator: true,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white)),
                    ),
                  ],
                ),
                Positioned(
                  top: 250,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: ScreenUtil().screenHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: textInApp(
                                  text: widget.course.title ?? "Course Name",
                                  color: const Color(0xff1D1B20))),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: textInApp(
                                  text: widget.course.instructor?.name ??
                                      "instructor Name",
                                  color: const Color(0xff1D1B20),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
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
                            height: 500.h,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
