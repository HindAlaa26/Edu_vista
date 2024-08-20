import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_utility.dart';
import 'default_text_component .dart';

class LectureScreen extends StatefulWidget {
  @override
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedLectureIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  List<String> lectureTitles = [
    'Introduction to C++',
    'First Code',
    'Pointers',
    'Arrays',
    'Structures',
    'Classes and Objects'
  ];
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
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage("assets/images/C++LectureImage.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 70,
                      left: 0,
                      right: 0,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                    const Positioned(
                      top: 16,
                      left: 16,
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 90,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.crop_free,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                          Slider(
                            value: 0.3,
                            onChanged: (value) {},
                            activeColor: Colors.red,
                            inactiveColor: ColorUtility.grey,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textInApp(
                              text: '10:00',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                          textInApp(
                              text: '30:00',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
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
                                  text: 'C++ for Beginners',
                                  color: const Color(0xff1D1B20))),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: textInApp(
                                  text: 'Robert Jackson',
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
                                buildLectureTab(),
                                buildDownloadTab(),
                                buildCertificateTab(),
                                buildMoreTab(),
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

  Widget buildLectureTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: lectureTitles.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) {
        return buildLectureItem(
            title: lectureTitles[index],
            isActive: index == selectedLectureIndex,
            subtitle: 'Lorem ipsum dolor sit amet consectetur.',
            lectureNumber: index + 1,
            duration: "5 min",
            onTap: () {
              setState(() {
                selectedLectureIndex = index;
              });
            });
      },
    );
  }

  Widget buildLectureItem(
      {required int lectureNumber,
      required String title,
      required String subtitle,
      bool isActive = false,
      required VoidCallback onTap,
      required String duration}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        color: isActive ? ColorUtility.secondary : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: textInApp(
                      text: "Lecture $lectureNumber",
                      fontSize: 14,
                      color: isActive ? Colors.white : ColorUtility.black,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.file_download_outlined,
                        size: 20,
                        color: isActive ? Colors.white : ColorUtility.black,
                      ))
                ],
              ),
              Flexible(
                child: textInApp(
                    text: title,
                    fontSize: 14,
                    color: isActive ? Colors.white : ColorUtility.black),
              ),
              Flexible(
                child: textInApp(
                    text: subtitle,
                    fontSize: 14,
                    color: isActive ? Colors.white : ColorUtility.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: textInApp(
                        text: "Duration $duration",
                        fontSize: 10,
                        color: isActive ? Colors.white : ColorUtility.black),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_outline,
                        size: 40,
                        color: isActive ? Colors.white : ColorUtility.black,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDownloadTab() {
    return Center(
      child: textInApp(
          text: 'Download Section', fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget buildCertificateTab() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 300.w,
          height: 400.h,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorUtility.grey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textInApp(
                  text: "Certificate of Completion",
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              SizedBox(height: 16.h),
              textInApp(text: "This is to certify that", fontSize: 16),
              SizedBox(height: 8.h),
              textInApp(
                  text: FirebaseAuth.instance.currentUser?.displayName ??
                      "Student Name",
                  fontSize: 18,
                  color: ColorUtility.secondary,
                  fontWeight: FontWeight.bold),
              SizedBox(height: 16.h),
              textInApp(
                  text:
                      "has successfully completed the course\nC++ for Beginners",
                  fontSize: 16),
              SizedBox(height: 24.h),
              textInApp(text: "Instructor Name", fontSize: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoreTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildMoreItem('About Instructor'),
        buildMoreItem('Course Resources'),
        buildMoreItem('Share this Course'),
      ],
    );
  }

  Widget buildMoreItem(String title) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      margin: const EdgeInsets.only(bottom: 15),
      child: ExpansionTile(
        title:
            textInApp(text: title, fontSize: 15, fontWeight: FontWeight.w500),
        trailing: const Icon(Icons.double_arrow),
        children: [
          SizedBox(height: 12.h),
          textInApp(
              text: 'Come soon...', fontSize: 14, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}
