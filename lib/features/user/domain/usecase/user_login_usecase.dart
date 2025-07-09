import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quickstock/app/shared_pref/token_shared_pref.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/repository/user_repository.dart';

class LoginUserParams extends Equatable {
  final String phoneNumber;
  final String password;

  const LoginUserParams({required this.phoneNumber, required this.password});

  const LoginUserParams.initial() : phoneNumber = '', password = '';
  @override
  List<Object?> get props => [phoneNumber, password];
}

class UserLoginUsecase implements UsecaseWithParams<String, LoginUserParams> {
  final IUserRepository _iUserRepository;
  final TokenSharedPref _tokenSharedPref;

  const UserLoginUsecase({
    required IUserRepository iUserRepository,
    required TokenSharedPref tokenSharedPref,
  }) : _iUserRepository = iUserRepository,
       _tokenSharedPref = tokenSharedPref;

  @override
  Future<Either<Failure, String>> call(LoginUserParams params) async {
    final token = await _iUserRepository.loginUser(
      params.phoneNumber,
      params.password,
    );

    return token.fold((failure) => Left(failure), (token) async {
      final saveResult = await _tokenSharedPref.saveToken(token);
      saveResult.fold(
        (failure) => debugPrint("Failed to save token: ${failure.message}"),
        (_) => debugPrint("Saved Token Successfully."),
      );
      return Right(token);
    });
  }
}
