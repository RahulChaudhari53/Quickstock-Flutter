import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/entity/user_entity.dart';
import 'package:quickstock/features/user/domain/usecase/user_register_usecase.dart';

import 'repository.mock.dart';

void main() {
  late MockUserRepository userRepository;
  late UserRegisterUsecase usecase;

  setUp(() {
    userRepository = MockUserRepository();
    registerFallbackValue(UserEntity.empty());
  });

  final params = RegisterUserParams(
    firstName: 'Jane',
    lastName: 'Doe',
    email: 'jane@example.com',
    primaryPhone: '9876543210',
    password: 'securePassword',
  );

  final fixedUuid = 'test-uuid';
  final fixedTime = DateTime(2025, 7, 9, 12, 45, 0);

  test('should register user successfully', () async {
    usecase = UserRegisterUsecase(
      iUserRepository: userRepository,
      uuidGenerator: () => fixedUuid,
      dateTimeProvider: () => fixedTime,
    );

    final expectedUser = UserEntity(
      userId: fixedUuid,
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      primaryPhone: '9876543210',
      password: 'securePassword',
      role: 'shop_owner',
      createdAt: fixedTime,
      updatedAt: fixedTime,
    );

    when(
      () => userRepository.registerUser(expectedUser),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(params);

    expect(result, const Right(null));
    verify(() => userRepository.registerUser(expectedUser)).called(1);
    verifyNoMoreInteractions(userRepository);
  });

  test('should return failure if registration fails', () async {
    usecase = UserRegisterUsecase(
      iUserRepository: userRepository,
      uuidGenerator: () => fixedUuid,
      dateTimeProvider: () => fixedTime,
    );

    final expectedUser = UserEntity(
      userId: fixedUuid,
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      primaryPhone: '9876543210',
      password: 'securePassword',
      role: 'shop_owner',
      createdAt: fixedTime,
      updatedAt: fixedTime,
    );

    final failure = RemoteDatabaseFailure(message: 'Registration Failed');

    when(
      () => userRepository.registerUser(expectedUser),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(params);

    expect(result, Left(failure));
    verify(() => userRepository.registerUser(expectedUser)).called(1);
    verifyNoMoreInteractions(userRepository);
  });
}
