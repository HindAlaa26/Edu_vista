import 'package:edu_vista/main.dart';
import 'package:edu_vista/shared_component/default_text_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'auth_screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  List<String> profileData = [
    "Edit",
    "Achievements",
    "About US",
  ];
  List<IconData> profileIcons = [
    Icons.edit,
    Icons.emoji_events,
    Icons.info,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textInApp(text: 'Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = AuthCubit.get(context).model;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                          "https://icons.veryicon.com/png/o/system/crm-android-app-icon/app-icon-person.png"),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.white,
                              )),
                        ))
                  ],
                ),
                SizedBox(height: 10.h),
                textInApp(
                    text: "${FirebaseAuth.instance.currentUser?.displayName}"),
                Text('${FirebaseAuth.instance.currentUser?.email}'),
                SizedBox(height: 50.h),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: ColorUtility.grey,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ExpansionTile(
                              leading: Icon(profileIcons[index]),
                              title: textInApp(text: profileData[index]),
                              trailing: const Icon(Icons.double_arrow_outlined),
                              children: [
                                textInApp(text: 'come soon...'),
                              ],
                            ),
                          ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemCount: profileData.length),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                      onTap: () async {
                        var result =
                            await context.read<AuthCubit>().logout(context);
                        if (result) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10.w),
                          textInApp(text: "Logout", color: Colors.red),
                        ],
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
