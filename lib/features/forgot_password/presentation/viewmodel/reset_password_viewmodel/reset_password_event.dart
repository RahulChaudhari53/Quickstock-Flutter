import 'package:flutter/material.dart';

@immutable
sealed class ResetPasswordEvent {}

class PasswordChanged extends ResetPasswordEvent {
  // this is fired by ui when user types in password filed
  final String password;

  PasswordChanged(this.password);
}

class ResetPasswordButtonPressed extends ResetPasswordEvent {
  // fired by ui when button is pressed
  final BuildContext context;
  final String newPassword;
  final String resetToken; // the token from previous screen

  ResetPasswordButtonPressed({
    required this.context,
    required this.newPassword,
    required this.resetToken,
  });
}

class NavigateToLogin extends ResetPasswordEvent {
  final BuildContext context;
  NavigateToLogin(this.context);
}
