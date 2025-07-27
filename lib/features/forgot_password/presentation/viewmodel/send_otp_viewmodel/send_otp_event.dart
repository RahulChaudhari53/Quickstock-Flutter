import 'package:flutter/material.dart';

@immutable
sealed class SendOtpEvent {}

class SendOtpRequested extends SendOtpEvent {
  final BuildContext context;
  final String email;

  SendOtpRequested({required this.context, required this.email});
}

class NavigateToVerifyOtp extends SendOtpEvent {
  final BuildContext context;
  final String email;
  final String tempToken; 

  NavigateToVerifyOtp({
    required this.context,
    required this.email,
    required this.tempToken,
  });
}
