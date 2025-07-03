import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/core/common/build_social_button.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/core/common/social_media_divider.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_state.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController(
    text: "Test",
  );
  final TextEditingController lastNameController = TextEditingController(
    text: "Mobile",
  );
  final TextEditingController emailController = TextEditingController(
    text: "mobile@example.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "1010101010",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "Mobile@123",
  );

  final ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> agreedToTerms = ValueNotifier(false);

  void handleRegister(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<RegisterViewModel>().add(
        UserRegisterEvent(
          context: context,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          primaryPhone: phoneController.text,
          // phoneNumber: phoneController.text,
          email: emailController.text,
          password: passwordController.text,
          agreedToTerms: agreedToTerms.value,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<RegisterViewModel, RegisterState>(
        listener: (context, state) {},
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Let's create your account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: firstNameController,
                        label: 'First Name',
                        hintText: 'Enter first name',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextFormField(
                        controller: lastNameController,
                        label: 'Last Name',
                        hintText: 'Enter last name',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  controller: emailController,
                  label: 'Email',
                  hintText: 'Enter email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  controller: phoneController,
                  label: 'Phone Number',
                  hintText: 'Enter phone number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
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
                      label: 'Password',
                      hintText: 'Enter password',
                      prefixIcon: Icons.lock,
                      obscureText: isObscure,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed:
                            () =>
                                obscurePassword.value = !obscurePassword.value,
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
                const SizedBox(height: 20),

                ValueListenableBuilder<bool>(
                  valueListenable: agreedToTerms,
                  builder: (context, isChecked, _) {
                    return Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged:
                              (bool? newValue) =>
                                  agreedToTerms.value = newValue ?? false,
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // Show policy screen if needed
                            },
                            child: const Text(
                              "I agree to the privacy policy and terms of use",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                BlocBuilder<RegisterViewModel, RegisterState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      onPressed: () {
                        if (!state.isLoading) {
                          handleRegister(context);
                        }
                      },
                      width: double.infinity,
                      height: 50,
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      child:
                          state.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                const SocialMediaDivider(type: "Sign Up"),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BuildSocialButton(
                      imagePath: 'assets/images/google_logo.png',
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    BuildSocialButton(
                      imagePath: 'assets/images/apple_logo_dark.png',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
