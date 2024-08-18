import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/shared_component/auth/auth_template.dart';
import 'package:edu_vista/shared_component/custom_textFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthTemplate(
          onLogin: () async {
            if (formKey.currentState?.validate() ?? false) {
              await context.read<AuthCubit>().login(
                  context: context,
                  emailController: emailController,
                  passwordController: passwordController);
            }
          },
          body: Form(
            key: formKey,
            child: Column(
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
      ),
    );
  }
}
