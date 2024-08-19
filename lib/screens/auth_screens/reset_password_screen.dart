import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/screens/auth_screens/login_screen.dart';
import 'package:edu_vista/shared_component/default_button_component .dart';
import 'package:edu_vista/shared_component/default_text_component .dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared_component/custom_textFormField_component .dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int currentPage = 0;
  var pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    bool result = await context.read<AuthCubit>().sendPasswordResetEmail(
        context: context, emailController: emailController);

    // if (result) {
    //   pageController.nextPage(
    //     duration: const Duration(seconds: 2),
    //     curve: Curves.linear,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 37.w),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                textInApp(text: "Reset Password"),
                SizedBox(height: 40.h),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    children: [
                      DefaultTextFormField(
                        controller: emailController,
                        validatorText: 'Email',
                        label: 'Email',
                        hintText: "demo@mail.com",
                      ),
                      Column(
                        children: [
                          DefaultTextFormField(
                            controller: passwordController,
                            validatorText: 'Password',
                            label: 'Password',
                            hintText: "********",
                            isPassword: true,
                          ),
                          DefaultTextFormField(
                            controller: confirmPasswordController,
                            validatorText: 'Confirm Password',
                            label: 'Confirm Password',
                            hintText: "********",
                            isPassword: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.h),
                  child: defaultButton(
                    text: "SUBMIT",
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        if (pageController.page == 0) {
                          await _sendResetEmail();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        } else {
                          //go to the next page
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
