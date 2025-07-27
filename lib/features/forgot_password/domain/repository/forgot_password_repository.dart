import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';

abstract interface class IForgotPasswordRepository {
  Future<Either<Failure, String>> sendOtp(String email);
  Future<Either<Failure, String>> verifyOtp(String otp, String tempToken);
  Future<Either<Failure, void>> resetPassword(
    String newPassword,
    String resetToken,
  );
}
