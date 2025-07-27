import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/forgot_password/data/data_source/remote_data_source/forgot_password_remote_data_source.dart';
import 'package:quickstock/features/forgot_password/domain/repository/forgot_password_repository.dart';

class ForgotPasswordRemoteRepository implements IForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource _forgotPasswordRemoteDataSource;

  ForgotPasswordRemoteRepository({
    required ForgotPasswordRemoteDataSource forgotPasswordRemoteDataSource,
  }) : _forgotPasswordRemoteDataSource = forgotPasswordRemoteDataSource;

  @override
  Future<Either<Failure, String>> sendOtp(String email) async {
    try {
      final token = await _forgotPasswordRemoteDataSource.sendOtp(email);
      return Right(token);
    } catch (err) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error"));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(
    String otp,
    String tempToken,
  ) async {
    try {
      final token = await _forgotPasswordRemoteDataSource.verifyOtp(
        otp,
        tempToken,
      );
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error"));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String newPassword,
    String resetToken,
  ) async {
    try {
      await _forgotPasswordRemoteDataSource.resetPassword(
        newPassword,
        resetToken,
      );
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error"));
    }
  }
}
