import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/screens/auth_screens/login_screen.dart';
import 'package:edu_vista/shared_component/default_button.dart';
import 'package:edu_vista/shared_component/default_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared_component/custom_textFormField.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    await context.read<AuthCubit>().sendPasswordResetEmail(
        context: context, emailController: emailController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: DefaultTextFormField(
                    controller: emailController,
                    validatorText: 'Email',
                    label: 'Email',
                    hintText: "demo@mail.com",
                  ),
                ),
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.h),
                  child: defaultButton(
                    text: "SUBMIT",
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        await _sendResetEmail();
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
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
