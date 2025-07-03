import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/core/common/build_social_button.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/core/common/social_media_divider.dart';
import 'package:quickstock/features/forgot_password/presentation/view/forgot_password_view.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController(
    text: "1010101010",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "Mobile@123",
  );
  final ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> rememberMe = ValueNotifier(false);

  void handleLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<LoginViewModel>().add(
        LoginWithPhoneNumberAndPasswordEvent(
          context: context,
          phoneNumber: phoneController.text,
          password: passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {}
        },
        child: SingleChildScrollView(
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
                        'assets/logo/quickstock_logo.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Welcome back, you've been missed!",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 1100),
                  duration: const Duration(milliseconds: 1500),
                  child: CustomTextFormField(
                    controller: phoneController,
                    label: "Phone Number",
                    hintText: "Enter your phone number",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number is required';
                      }
                      if (value.length < 10) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  duration: const Duration(milliseconds: 1500),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: obscurePassword,
                    builder: (context, isObscure, _) {
                      return CustomTextFormField(
                        controller: passwordController,
                        label: "Password",
                        hintText: "Enter your password",
                        prefixIcon: Icons.lock_outline,
                        keyboardType: TextInputType.text,
                        obscureText: isObscure,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => obscurePassword.value = !isObscure,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      );
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
                      ValueListenableBuilder<bool>(
                        valueListenable: rememberMe,
                        builder: (context, value, _) {
                          return Row(
                            children: [
                              Checkbox(
                                value: value,
                                onChanged:
                                    (val) => rememberMe.value = val ?? false,
                              ),
                              const Text("Remember Me"),
                            ],
                          );
                        },
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
                  child: BlocBuilder<LoginViewModel, LoginState>(
                    builder: (context, state) {
                      return CustomElevatedButton(
                        onPressed: () {
                          if (!state.isLoading) {
                            handleLogin(context);
                          }
                        },
                        width: double.infinity,
                        height: 55,
                        child:
                            state.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text("Login"),
                      );
                    },
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
                          context.read<LoginViewModel>().add(
                            NavigateToRegisterViewEvent(context: context),
                          );
                        },
                        child: const Text(
                          "Register Now",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
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
