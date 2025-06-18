import 'package:flutter/material.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  void handleSendResetEmail() {
    if (formKey.currentState!.validate()) {
      final email = emailController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Forgot your password?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter your email address below and we will send you a link to reset your password.',
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: emailController,
                  label: "Email",
                  hintText: "Enter your email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: handleSendResetEmail,
                    width: double.infinity,
                    height: 55,
                    child: const Text("Send Password Reset Email"),
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
