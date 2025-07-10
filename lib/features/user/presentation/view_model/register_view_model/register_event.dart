import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class UserRegisterEvent extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String primaryPhone;
  final String email;
  final String password;
  final bool agreedToTerms;

  UserRegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.primaryPhone,
    required this.email,
    required this.password,
    required this.agreedToTerms,
  });
}
