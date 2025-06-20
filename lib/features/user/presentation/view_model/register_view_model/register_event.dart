import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class UserRegisterEvent extends RegisterEvent {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String password;
  final bool agreedToTerms;

  UserRegisterEvent({
    required this.context,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.agreedToTerms,
  });
}
