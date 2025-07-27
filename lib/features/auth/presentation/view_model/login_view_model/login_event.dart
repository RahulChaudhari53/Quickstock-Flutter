import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

class NavigateToRegisterViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToRegisterViewEvent({required this.context});
}

class NavigateToDashboardViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToDashboardViewEvent({required this.context});
}

class LoginWithPhoneNumberAndPasswordEvent extends LoginEvent {
  final BuildContext context;
  final String phoneNumber;
  final String password;

  LoginWithPhoneNumberAndPasswordEvent({
    required this.context,
    required this.phoneNumber,
    required this.password,
  });
}

class NavigateToForgotPasswordViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToForgotPasswordViewEvent({required this.context});
}
