import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToRegisterViewEvent extends LoginEvent {
  const NavigateToRegisterViewEvent();
}

class NavigateToDashboardViewEvent extends LoginEvent {
  const NavigateToDashboardViewEvent();
}

class LoginWithPhoneNumberAndPasswordEvent extends LoginEvent {
  final String phoneNumber;
  final String password;

  const LoginWithPhoneNumberAndPasswordEvent({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, password];
}
