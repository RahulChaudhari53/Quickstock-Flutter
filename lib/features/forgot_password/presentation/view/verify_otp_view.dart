// /presentation/view/verify_otp_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_event.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_state.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_view_model.dart';

class VerifyOtpView extends StatelessWidget {
  final String email;
  final String tempToken;

  VerifyOtpView({super.key, required this.email, required this.tempToken});

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // pinput theme
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: textTheme.headlineMedium,
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: theme.colorScheme.primary, width: 2),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: theme.colorScheme.error, width: 1.5),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BlocBuilder<VerifyOtpViewModel, VerifyOtpState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    Text(
                      'Check Your Email',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We've sent a 6-digit OTP to $email.",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Pinput(
                            controller: _otpController,
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            errorPinTheme: errorPinTheme,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Please enter the 6-digit OTP';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          CustomElevatedButton(
                            onPressed:
                                state.isVerifying
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<VerifyOtpViewModel>().add(
                                          VerifyOtpRequested(
                                            context: context,
                                            otp: _otpController.text,
                                            tempToken: tempToken,
                                          ),
                                        );
                                      }
                                    },
                            height: 56,
                            child:
                                state.isVerifying
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                    : const Text("Verify OTP"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code?",
                          style: textTheme.bodyMedium,
                        ),
                        if (state.countdown > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Resend in ${state.countdown}s',
                              style: textTheme.bodyMedium,
                            ),
                          )
                        else
                          state.isResending
                              ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                              : TextButton(
                                onPressed: () {
                                  context.read<VerifyOtpViewModel>().add(
                                    ResendOtpRequested(
                                      context: context,
                                      email: email,
                                    ),
                                  );
                                },
                                child: const Text("Request a new one"),
                              ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
