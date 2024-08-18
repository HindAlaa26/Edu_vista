import 'package:edu_vista/screens/auth_screens/login_screen.dart';
import 'package:edu_vista/screens/auth_screens/sign_up_screen.dart';
import 'package:edu_vista/shared_component/default_button.dart';
import 'package:edu_vista/shared_component/default_text.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';

import '../../screens/auth_screens/reset_password_screen.dart';

class AuthTemplate extends StatefulWidget {
  final Future<void> Function()? onLogin;
  final Future<void> Function()? onSignUp;
  final Widget body;
  AuthTemplate({this.onLogin, this.onSignUp, required this.body, super.key}) {
    assert(onLogin != null || onSignUp != null,
        'onLogin or onSignUp should not be null');
  }

  @override
  State<AuthTemplate> createState() => _AuthTemplateState();
}

class _AuthTemplateState extends State<AuthTemplate> {
  bool get isLogin => widget.onLogin != null;

  String get title => isLogin ? "Login" : "Sign Up";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 69, bottom: 20, left: 37, right: 37),
        child: Column(
          children: [
            textInApp(text: title, fontSize: 20),
            const SizedBox(height: 40),
            widget.body,
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  textInApp(
                      text: "Forget Password?",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorUtility.secondary),
                ],
              ),
            ),
            const SizedBox(height: 50),
            isLoading
                ? const CircularProgressIndicator(
                    color: ColorUtility.main,
                  )
                : defaultButton(
                    text: isLogin ? "LOGIN" : "Sign Up",
                    onTap: () async {
                      if (isLogin) {
                        setState(() {
                          isLoading = true;
                        });
                        await widget.onLogin?.call();
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        await widget.onSignUp?.call();
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Divider(
                    height: 103,
                    color: ColorUtility.grey,
                    thickness: 3,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                textInApp(
                    text: "Or Sign In With",
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                const SizedBox(
                  width: 6,
                ),
                const Expanded(
                  child: Divider(
                    height: 103,
                    color: ColorUtility.grey,
                    thickness: 3,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // sign in with Facebook
                Container(
                  padding: const EdgeInsets.only(
                      left: 11, top: 15, right: 11, bottom: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xff1877F2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      textInApp(
                          text: "Sign In with Facebook",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // sign in with Google
                Container(
                  height: 60,
                  width: 80,
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorUtility.grey),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/google.png"),
                          fit: BoxFit.fill)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            //Don’t have an account? Sign Up Here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textInApp(
                    text: isLogin
                        ? "Don’t have an account?"
                        : "Already have an account?",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff6C6C6C)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              isLogin ? SignUpScreen() : LoginScreen(),
                        ));
                  },
                  child: textInApp(
                      text: isLogin ? " Sign Up Here" : " Login Here",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: ColorUtility.secondary),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
