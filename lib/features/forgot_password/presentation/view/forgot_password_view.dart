import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/send_otp_viewmodel/send_otp_event.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/send_otp_viewmodel/send_otp_state.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/send_otp_viewmodel/send_otp_view_model.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<SendOtpViewModel>(),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<SendOtpViewModel, SendOtpState>(
            builder: (context, state) {
              final theme = Theme.of(context);
              final textTheme = theme.textTheme;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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

                      CustomTextFormField(
                        controller: _emailController,
                        label: "Email Address",
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
                      const SizedBox(height: 32),

                      CustomElevatedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<SendOtpViewModel>().add(
                                      SendOtpRequested(
                                        context: context,
                                        email: _emailController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                        height: 56,
                        child:
                            state.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text("Send Reset Link"),
                      ),
                      const SizedBox(height: 24),

                      // --- Footer Navigation (Same as before) ---
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
              );
            },
          ),
        ),
      ),
    );
  }
}
