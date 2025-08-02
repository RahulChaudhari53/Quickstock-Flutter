import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';

@immutable
class ProfileState extends Equatable {
  final ProfileEntity? user;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? actionError;
  final String? successMessage;
  final bool isLoggedOut;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.actionError,
    this.successMessage,
    this.isLoggedOut = false,
  });

  const ProfileState.initial()
    : user = null,
      isLoading = true,
      isSubmitting = false,
      errorMessage = null,
      actionError = null,
      successMessage = null,
      isLoggedOut = false;

  ProfileState copyWith({
    ProfileEntity? user,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? actionError,
    bool clearActionError = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    bool? isLoggedOut,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      actionError: clearActionError ? null : actionError ?? this.actionError,
      successMessage:
          clearSuccessMessage ? null : successMessage ?? this.successMessage,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }

  @override
  List<Object?> get props => [
    user,
    isLoading,
    isSubmitting,
    errorMessage,
    actionError,
    successMessage,
    isLoggedOut,
  ];
}
