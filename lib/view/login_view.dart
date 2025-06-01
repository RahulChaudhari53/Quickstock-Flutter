import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:quickstock/common/build_social_button.dart';
import 'package:quickstock/common/custom_elevated_button.dart';
import 'package:quickstock/common/custom_text_form_field.dart';
import 'package:quickstock/common/social_media_divider.dart';
import 'package:quickstock/view/dashboard_view.dart';
import 'package:quickstock/view/forgot_password_view.dart';
import 'package:quickstock/view/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(milliseconds: 1500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/logo.png',
                      width: 130,
                      height: 130,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Welcome back, you've been missed!",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 1100),
                duration: const Duration(milliseconds: 1500),
                child: CustomTextFormField(
                  controller: emailController,
                  label: "Email",
                  hintText: "Enter your email",
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 1200),
                duration: const Duration(milliseconds: 1500),
                child: CustomTextFormField(
                  controller: passwordController,
                  label: "Password",
                  hintText: "Enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 1300),
                duration: const Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const Text("Remember Me"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordView(),
                          ),
                        );
                      },
                      child: const Text("Forgot Password?"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 1400),
                duration: const Duration(milliseconds: 1500),
                child: CustomElevatedButton(
                  onPressed: handleLogin,
                  width: double.infinity,
                  height: 55,
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 1500),
                duration: const Duration(milliseconds: 1500),
                child: const SocialMediaDivider(type: "Login"),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 1600),
                duration: const Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BuildSocialButton(
                      imagePath: 'assets/images/google_logo.png',
                      onPressed: () {},
                    ),
                    const SizedBox(width: 24),
                    BuildSocialButton(
                      imagePath: 'assets/images/apple_logo_dark.png',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 1700),
                duration: const Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupView()),
                        );
                      },
                      child: const Text("Register Now"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
