import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> rememberMe = ValueNotifier(false);

  void handleLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<LoginViewModel>().add(
        LoginWithPhoneNumberAndPasswordEvent(
          context: context,
          phoneNumber: phoneController.text.trim(),
          password: passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        "assets/logo/quickstock-logo.svg",
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Welcome Back",
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to manage your inventory and orders",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 40),

                      CustomTextFormField(
                        controller: phoneController,
                        label: "Phone Number",
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone Number is required';
                          }
                          if (value.length < 10) {
                            return 'Enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      ValueListenableBuilder<bool>(
                        valueListenable: obscurePassword,
                        builder: (context, isObscure, _) {
                          return CustomTextFormField(
                            controller: passwordController,
                            label: "Password",
                            prefixIcon: Icons.lock_outline,
                            obscureText: isObscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed:
                                  () => obscurePassword.value = !isObscure,
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
                            keyboardType: TextInputType.text,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // ValueListenableBuilder<bool>(
                          //   valueListenable: rememberMe,
                          //   builder: (context, value, _) {
                          //     return InkWell(
                          //       onTap: () => rememberMe.value = !value,
                          //       borderRadius: BorderRadius.circular(8),
                          //       child: Row(
                          //         children: [
                          //           Checkbox(
                          //             value: value,
                          //             onChanged:
                          //                 (val) =>
                          //                     rememberMe.value = val ?? false,
                          //           ),
                          //           Text(
                          //             "Remember Me",
                          //             style: textTheme.labelMedium,
                          //           ),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          // ),
                          TextButton(
                            onPressed: () {
                              context.read<LoginViewModel>().add(
                                NavigateToForgotPasswordViewEvent(
                                  context: context,
                                ),
                              );
                            },
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      CustomElevatedButton(
                        onPressed:
                            state.isLoading ? null : () => handleLogin(context),
                        height: 56,
                        child:
                            state.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                                : const Text("Login"),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<LoginViewModel>().add(
                                NavigateToRegisterViewEvent(context: context),
                              );
                            },
                            child: const Text("Sign Up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
