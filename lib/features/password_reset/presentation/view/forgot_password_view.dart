import 'package:flutter/material.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/features/password_reset/presentation/view/verify_otp_view.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(
    false,
  ); 

  void handleSendResetEmail(BuildContext context) async {
    if (isLoading.value) return;

    if (formKey.currentState!.validate()) {
      final email = emailController.text.trim();

      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      // On success, navigate to the OTP verification screen
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to $email'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtpView(email: email)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Header ---
                Text(
                  'Forgot Password?',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter your email and we'll send a code to reset your password.",
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // --- Email Input ---
                CustomTextFormField(
                  controller: emailController,
                  label: "Email Address",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // --- Submit Button ---
                // This button now shows a loading state
                ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, value, _) {
                    return CustomElevatedButton(
                      onPressed:
                          value ? null : () => handleSendResetEmail(context),
                      height: 56,
                      child:
                          value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              )
                              : const Text("Send Reset Link"),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // --- Footer Navigation ---
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text("Back to Login"),
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
