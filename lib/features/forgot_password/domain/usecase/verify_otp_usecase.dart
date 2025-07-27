import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/forgot_password/domain/repository/forgot_password_repository.dart';

class VerifyOtpParams extends Equatable {
  final String otp;
  final String tempToken;

  const VerifyOtpParams({required this.otp, required this.tempToken});

  @override
  List<Object?> get props => [otp, tempToken];
}

class VerifyOtpUseCase implements UsecaseWithParams<String, VerifyOtpParams> {
  final IForgotPasswordRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    final result = await _repository.verifyOtp(params.otp, params.tempToken);
    return result.fold((failure) => Left(failure), (resetToken) {
      debugPrint("OTP verified, reset token: $resetToken");
      return Right(resetToken);
    });
  }
}
