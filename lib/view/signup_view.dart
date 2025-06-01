import 'package:flutter/material.dart';
import 'package:quickstock/common/build_social_button.dart';
import 'package:quickstock/common/custom_elevated_button.dart';
import 'package:quickstock/common/custom_text_form_field.dart';
import 'package:quickstock/common/social_media_divider.dart';
import 'package:quickstock/view/dashboard_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool agreedToTerms = false;

  void handleNavigate() {
    if (formKey.currentState!.validate() && agreedToTerms) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    } else if (!agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the privacy policy and terms.'),
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
      body: SingleChildScrollView(
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

              // First Name & Last Name row using CustomTextFormField
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

              // Email
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

              // Phone Number
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

              // Password with toggle using CustomTextFormField
              CustomTextFormField(
                controller: passwordController,
                label: 'Password',
                hintText: 'Enter password',
                prefixIcon: Icons.lock,
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
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
              ),
              const SizedBox(height: 20),

              // Checkbox for terms agreement
              Row(
                children: [
                  Checkbox(
                    value: agreedToTerms,
                    onChanged: (bool? newValue) {
                      setState(() {
                        agreedToTerms = newValue ?? false;
                      });
                    },
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "I agree to the privacy policy and terms of use",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Create Account button using CustomElevatedButton
              CustomElevatedButton(
                onPressed: handleNavigate,
                width: double.infinity,
                height: 50,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                child: const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              // Divider Or Sign Up With
              const SocialMediaDivider(type: "Sign Up"),
              const SizedBox(height: 30),

              // Social login buttons using BuildSocialButton
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
    );
  }
}
