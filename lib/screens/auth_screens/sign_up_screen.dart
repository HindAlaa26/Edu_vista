import 'package:edu_vista/shared_component/auth/auth_template.dart';
import 'package:edu_vista/shared_component/custom_textFormField.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthTemplate(
          onSignUp: () {},
          body: Column(
            children: [
              DefaultTextFormField(
                controller: fullNameController,
                validatorText: 'Full Name',
                label: 'Full Name',
                hintText: "Muhammad Rafey",
              ),
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
              ),
              DefaultTextFormField(
                controller: confirmPasswordController,
                validatorText: 'Confirm Password',
                label: 'Confirm Password',
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
