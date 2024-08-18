import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../chat_screen.dart';
import '../courses_screen.dart';
import '../home_screen.dart';
import '../profile_screen.dart';
import '../search_screen.dart';

class HomeLayoutScreen extends StatefulWidget {
  HomeLayoutScreen({super.key});

  @override
  State<HomeLayoutScreen> createState() => _HomeLayoutScreenState();
}

class _HomeLayoutScreenState extends State<HomeLayoutScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    CoursesScreen(),
    SearchScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: "",
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: const Divider(
                      thickness: 2,
                      color: ColorUtility.secondary,
                    ),
                  )
                ],
              )),
          BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_rounded),
              label: "",
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book_rounded),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: const Divider(
                      thickness: 2,
                      color: ColorUtility.secondary,
                    ),
                  )
                ],
              )),
          BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: "",
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: const Divider(
                      thickness: 2,
                      color: ColorUtility.secondary,
                    ),
                  )
                ],
              )),
          BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: "",
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: const Divider(
                      thickness: 2,
                      color: ColorUtility.secondary,
                    ),
                  )
                ],
              )),
          BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: "",
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: const Divider(
                      thickness: 2,
                      color: ColorUtility.secondary,
                    ),
                  )
                ],
              )),
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedItemColor: ColorUtility.secondary,
        unselectedItemColor: ColorUtility.black,
      ),
    );
  }
}
