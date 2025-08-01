import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileFetchStartEvent extends ProfileEvent {}

class ProfileInfoUpdateEvent extends ProfileEvent {
  final String firstName;
  final String lastName;

  const ProfileInfoUpdateEvent({
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [firstName, lastName];
}

class ProfilePasswordUpdateEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ProfilePasswordUpdateEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class ProfileEmailUpdateEvent extends ProfileEvent {
  final String email;

  const ProfileEmailUpdateEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ProfileImageUpdateEvent extends ProfileEvent {
  final File image;

  const ProfileImageUpdateEvent({required this.image});

  @override
  List<Object?> get props => [image];
}

class ProfilePhoneNumberAddEvent extends ProfileEvent {
  final String phoneNumber;

  const ProfilePhoneNumberAddEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class ProfilePhoneNumberDeleteEvent extends ProfileEvent {
  final String phoneNumber;

  const ProfilePhoneNumberDeleteEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class ProfileAccountDeactivateEvent extends ProfileEvent {}

class ProfileFeedbackMessageClearedEvent extends ProfileEvent {}
