import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/forgot_password/domain/repository/forgot_password_repository.dart';

class ResetPasswordParams extends Equatable {
  final String newPassword;
  final String resetToken;

  const ResetPasswordParams({
    required this.newPassword,
    required this.resetToken,
  });

  @override
  List<Object?> get props => [newPassword, resetToken];
}

class ResetPasswordUseCase
    implements UsecaseWithParams<void, ResetPasswordParams> {
  final IForgotPasswordRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    final result = await _repository.resetPassword(
      params.newPassword,
      params.resetToken,
    );
    return result.fold((failure) => Left(failure), (_) {
      debugPrint("Password reset successfully.");
      return const Right(null);
    });
  }
}
