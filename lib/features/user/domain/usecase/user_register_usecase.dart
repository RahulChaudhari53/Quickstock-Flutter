import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/entity/user_entity.dart';
import 'package:quickstock/features/user/domain/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class RegisterUserParams extends Equatable {
  final String firstName;
  final String lastName;
  final List<String> phoneNumbers;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.email,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phoneNumbers,
    email,
    password,
  ];
}

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _iUserRepository;

  UserRegisterUsecase({required IUserRepository iUserRepository})
    : _iUserRepository = iUserRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      userId: const Uuid().v4().toString(),
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumbers: params.phoneNumbers,
      email: params.email,
      password: params.password,
      role: "shop_owner",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return _iUserRepository.registerUser(userEntity);
  }
}
