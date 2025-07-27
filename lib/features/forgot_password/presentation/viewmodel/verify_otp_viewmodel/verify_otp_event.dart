import 'package:flutter/material.dart';

@immutable
sealed class VerifyOtpEvent {}

class TimerTicked extends VerifyOtpEvent {
  final int newTime;

  TimerTicked(this.newTime);
}

class VerifyOtpRequested extends VerifyOtpEvent {
  final BuildContext context;
  final String otp;
  final String tempToken; // token from the previous screen

  VerifyOtpRequested({
    required this.context,
    required this.otp,
    required this.tempToken,
  });
}

class ResendOtpRequested extends VerifyOtpEvent {
  final BuildContext context;
  final String email; // needed for otp api call

  ResendOtpRequested({required this.context, required this.email});
}

class NavigateToResetPassword extends VerifyOtpEvent {
  final BuildContext context;
  final String resetToken; // token we get after verifying OTP

  NavigateToResetPassword({required this.context, required this.resetToken});
}
