import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
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

  const UserLoginUsecase({required IUserRepository iUserRepository})
    : _iUserRepository = iUserRepository;

  @override
  Future<Either<Failure, String>> call(LoginUserParams params) async {
    return await _iUserRepository.loginUser(
      params.phoneNumber,
      params.password,
    );
  }
}
