import 'package:edu_vista/shared_component/auth/auth_template.dart';
import 'package:edu_vista/shared_component/custom_textFormField.dart';
import 'package:edu_vista/shared_component/default_button.dart';
import 'package:edu_vista/shared_component/default_text.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthTemplate(
          onLogin: () {},
          body: Column(
            children: [
              DefaultTextFormField(
                controller: emailController,
                validatorText: 'Email',
                label: 'Email',
                hintText: "demo@mail.com",
              ),
              DefaultTextFormField(
                controller: passwordController,
                validatorText: 'Password',
                label: 'Password',
                hintText: "**********************",
                isPassword: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
