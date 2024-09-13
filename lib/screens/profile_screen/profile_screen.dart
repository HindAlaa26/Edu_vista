import 'package:edu_vista/services/pref_service.dart';
import 'package:edu_vista/shared_component/default_button_component%20.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import '../../models/user_model.dart';
import '../../shared_component/custom_textFormField_component .dart';
import '../../shared_component/default_text_component .dart';
import '../../shared_component/shopping_icon_widget.dart';
import '../auth_screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
  Color? textColor;

  @override
  void initState() {
    super.initState();
    _loadTextColor();
  }

  Future<void> _loadTextColor() async {
    int? savedColorValue = await PreferencesService.getTextColor();
    if (savedColorValue != null) {
      setState(() {
        textColor = Color(savedColorValue);
      });
    }
  }

  Future<void> _saveTextColor(Color color) async {
    setState(() {
      textColor = color;
    });
    await PreferencesService.saveTextColor(color.value);
  }

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
        actions: [shoppingIcon()],
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
                              backgroundColor: ColorUtility.main,
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
                      textInApp(
                          text: "${user.name}",
                          color: textColor ?? ColorUtility.black),
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
                                    Padding(
                                      padding: const EdgeInsets.all(28.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          textInApp(text: "Choose name color:"),
                                          SizedBox(height: 28.0.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _saveTextColor(
                                                      ColorUtility.main);
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      ColorUtility.main,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _saveTextColor(
                                                      ColorUtility.secondary);
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      ColorUtility.secondary,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _saveTextColor(
                                                      ColorUtility.black);
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      ColorUtility.black,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  else if (index == 2)
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: textInApp(
                                          text:
                                              " Edu Vista application is a versatile mobile application that starts by allowing users to securely log in or reset their password via email if forgotten. Once logged in, users can explore a diverse range of paid courses, view lecture content, and manage their profile details such as name and image. The app features a comprehensive catalog of courses, which includes options to search for specific topics and see trending courses. Users can view both their purchased courses and available courses, add courses to their cart, and complete transactions securely via Paymob. Additionally, users have the option to delete their accounts if needed, ensuring a personalized and flexible learning experience. s"),
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
