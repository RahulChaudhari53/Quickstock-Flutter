import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/entity/user_entity.dart';
import 'package:quickstock/features/user/domain/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

// ➤ Type aliases for injection
typedef UuidGenerator = String Function();
typedef DateTimeProvider = DateTime Function();

class RegisterUserParams extends Equatable {
  final String firstName;
  final String lastName;
  final String primaryPhone;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.firstName,
    required this.lastName,
    required this.primaryPhone,
    required this.email,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.firstName,
    required this.lastName,
    required this.primaryPhone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    primaryPhone,
    email,
    password,
  ];
}

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _iUserRepository;
  final UuidGenerator _uuidGenerator;
  final DateTimeProvider _dateTimeProvider;

  UserRegisterUsecase({
    required IUserRepository iUserRepository,
    UuidGenerator? uuidGenerator,
    DateTimeProvider? dateTimeProvider,
  }) : _iUserRepository = iUserRepository,
       _uuidGenerator = uuidGenerator ?? const Uuid().v4,
       _dateTimeProvider = dateTimeProvider ?? DateTime.now;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final now = _dateTimeProvider();

    final userEntity = UserEntity(
      userId: _uuidGenerator(),
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      primaryPhone: params.primaryPhone,
      password: params.password,
      role: 'shop_owner',
      createdAt: now,
      updatedAt: now,
    );

    return _iUserRepository.registerUser(userEntity);
  }
}
