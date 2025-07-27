import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/features/auth/presentation/view/reset_password_view.dart';

class VerifyOtpView extends StatefulWidget {
  final String email;
  const VerifyOtpView({super.key, required this.email});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = ValueNotifier(false);
  final isResending = ValueNotifier(false);

  late Timer _timer;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  void handleVerifyOtp() async {
    if (isLoading.value) return;

    // Validate the OTP input
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      if (mounted) {
        // On success, navigate to the next step
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordView(email: widget.email),
          ),
        );
      }
    }
  }

  void handleResendOtp() async {
    if (isResending.value) return;

    isResending.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate network call
    isResending.value = false;

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('A new OTP has been sent.')));
      startTimer(); // Restart the timer
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // --- Pinput Themes ---
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
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // --- Header ---
                Text(
                  'Check Your Email',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "We've sent a 6-digit OTP to ${widget.email}.",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),

                // --- Form Container ---
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
                      // --- OTP Input Field ---
                      Pinput(
                        controller: otpController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        errorPinTheme: errorPinTheme,
                        validator:
                            (s) => s == '123456' ? null : 'Pin is incorrect',
                      ),
                      const SizedBox(height: 24),

                      // --- Submit Button ---
                      ValueListenableBuilder<bool>(
                        valueListenable: isLoading,
                        builder: (context, value, _) {
                          return CustomElevatedButton(
                            onPressed: value ? null : handleVerifyOtp,
                            height: 56,
                            child:
                                value
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                    : const Text("Verify OTP"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Resend Code Link with Countdown ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: textTheme.bodyMedium,
                    ),
                    if (_countdown > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Resend in $_countdown'
                          's',
                          style: textTheme.bodyMedium,
                        ),
                      )
                    else
                      ValueListenableBuilder<bool>(
                        valueListenable: isResending,
                        builder: (context, value, _) {
                          return value
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
                                onPressed: handleResendOtp,
                                child: const Text("Request a new one"),
                              );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
