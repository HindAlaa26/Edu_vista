import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/pref_service.dart';
import '../../shared_component/auth_components/auth_template.dart';
import '../../shared_component/custom_textFormField.dart';
import '../layout_screens/home_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
              var result = await context.read<AuthCubit>().login(
                  context: context,
                  emailController: emailController,
                  passwordController: passwordController);
              if (result) {
                if (!context.mounted) return;
                PreferencesService.isLogin = true;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeLayoutScreen(),
                    ));
              }
            }
          },
          body: Form(
            key: formKey,
            child: Column(
              children: [
                DefaultTextFormField(
                  controller: emailController,
                  validatorText: 'Email',
                  keyboardType: TextInputType.emailAddress,
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
