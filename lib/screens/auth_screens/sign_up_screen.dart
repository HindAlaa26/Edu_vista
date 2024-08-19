import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/screens/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared_component/auth_components/auth_template_component.dart';
import '../../shared_component/custom_textFormField_component .dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var fullNameController = TextEditingController();

  var emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();
  @override
  void initState() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthTemplate(
          onSignUp: () async {
            if (formKey.currentState?.validate() ?? false) {
              var result = await context.read<AuthCubit>().signUp(
                  context: context,
                  emailController: emailController,
                  nameController: fullNameController,
                  passwordController: passwordController);
              if (result) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              }
            }
          },
          body: Form(
            key: formKey,
            child: Column(
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
      ),
    );
  }
}
