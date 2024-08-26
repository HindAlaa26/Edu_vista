import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/services/pref_service.dart';
import 'package:edu_vista/shared_component/default_button_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../models/user_model.dart';
import '../shared_component/custom_textFormField_component .dart';
import '../shared_component/default_text_component .dart';
import 'auth_screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> profileData = [
    "Edit",
    "Settings",
    "About US",
  ];

  List<IconData> profileIcons = [
    Icons.edit,
    Icons.settings,
    Icons.info,
  ];
  var nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => AuthCubit()..fetchUserData(),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorUtility.secondary,
                  ),
                );
              } else if (state is UserLoaded) {
                UserModel user = state.user;
                nameController.text = user.name ?? "";

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: user.image!.isNotEmpty
                                ? NetworkImage(user.image ?? "")
                                : const NetworkImage(
                                    "https://icons.veryicon.com/png/o/system/crm-android-app-icon/app-icon-person.png"),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: IconButton(
                                onPressed: () async {
                                  await context
                                      .read<AuthCubit>()
                                      .uploadImage(context);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      textInApp(text: "${user.name}"),
                      Text('${user.email}'),
                      SizedBox(height: 50.h),
                      SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            profileData.length,
                            (index) => Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              margin: EdgeInsets.symmetric(vertical: 10.h),
                              color: ColorUtility.grey,
                              child: ExpansionTile(
                                leading: Icon(profileIcons[index]),
                                title: textInApp(text: profileData[index]),
                                trailing:
                                    const Icon(Icons.double_arrow_outlined),
                                children: [
                                  if (index == 0)
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: textInApp(
                                                      text: "Name:",
                                                      color: Colors
                                                          .green.shade900)),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16),
                                                  child: DefaultTextFormField(
                                                    controller: nameController,
                                                    validatorText: 'name',
                                                    hintText:
                                                        user.name ?? "name",
                                                    enableBorder: false,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: defaultButton(
                                                text: "Edit",
                                                onTap: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    context
                                                        .read<AuthCubit>()
                                                        .updateUserData(
                                                          name: nameController
                                                              .text,
                                                          context: context,
                                                        );
                                                  }
                                                }),
                                          )
                                        ],
                                      ),
                                    )
                                  else if (index == 1)
                                    textInApp(text: profileData[index])
                                  else if (index == 2)
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: textInApp(
                                          text:
                                              "Welcome to Edu Vista our premier destination for mastering programming and technology. At Edu Vista, we believe in empowering individuals with the skills needed to thrive in the ever-evolving world of programming. Our platform offers a comprehensive range of courses, tutorials, and resources designed to make learning programming both accessible and enjoyable. Whether you’re a beginner taking your first steps in coding or an experienced developer looking to sharpen your skills, Edu Vista provides the tools and guidance you need to achieve your goals. Join our community of passionate learners and take the next step in your programming journey with Edu Vista."),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () async {
                            PreferencesService.isLogin = false;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () async {
                            var result = await context
                                .read<AuthCubit>()
                                .deleteUser(context);
                            if (result) {
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_remove,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10.w),
                              textInApp(
                                  text: "Delete Account", color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is UserError) {
                return Center(child: textInApp(text: state.message));
              } else {
                return Center(child: textInApp(text: 'Please wait...'));
              }
            },
          ),
        ),
      ),
    );
  }
}
