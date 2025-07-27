import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/forgot_password/domain/repository/forgot_password_repository.dart';

class SendOtpParams extends Equatable {
  final String email;

  const SendOtpParams(this.email);

  @override
  List<Object?> get props => [email];
}

class SendOtpUseCase implements UsecaseWithParams<String, SendOtpParams> {
  final IForgotPasswordRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(SendOtpParams params) async {
    final result = await _repository.sendOtp(params.email);
    return result.fold((failure) => Left(failure), (tempToken) {
      debugPrint("OTP sent successfully, temp token: $tempToken");
      return Right(tempToken);
    });
  }
}