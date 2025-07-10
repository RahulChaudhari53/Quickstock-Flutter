import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/usecase/user_login_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockUserRepository userRepository;
  late MockTokenSharedPref tokenSharedPref;
  late UserLoginUsecase usecase;

  setUp(() {
    userRepository = MockUserRepository();
    tokenSharedPref = MockTokenSharedPref();
    usecase = UserLoginUsecase(
      iUserRepository: userRepository,
      tokenSharedPref: tokenSharedPref,
    );
  });

  const params = LoginUserParams(
    phoneNumber: "1234567890",
    password: "password!123",
  );

  const token = "mocked-user-token";

  group("User Login Usecase", () {
    test('should login successfully and save token', () async {
      when(
        () => userRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => Right(token));

      when(
        () => tokenSharedPref.saveToken(any()),
      ).thenAnswer((_) async => Right(null));

      final result = await usecase(params);

      expect(result, Right(token));

      verify(
        () => userRepository.loginUser("1234567890", "password!123"),
      ).called(1);
      verify(() => tokenSharedPref.saveToken(token)).called(1);

      verifyNoMoreInteractions(userRepository);
      verifyNoMoreInteractions(tokenSharedPref);
    });
  });

  test('should return failure when login fails', () async {
    final failure = RemoteDatabaseFailure(message: 'Login Failed');

    when(
      () => userRepository.loginUser(any(), any()),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(params);

    expect(result, Left(failure));

    verify(
      () => userRepository.loginUser('1234567890', 'password!123'),
    ).called(1);
    verifyNoMoreInteractions(userRepository);
    verifyZeroInteractions(tokenSharedPref);
  });

  test(
    'should return success even if saving token fails (but print error)',
    () async {
      when(
        () => userRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Right(token));

      when(() => tokenSharedPref.saveToken(token)).thenAnswer(
        (_) async =>
            Left(SharedPreferenceFailure(message: 'Failed to save token')),
      );

      final result = await usecase(params);

      expect(result, const Right(token));

      verify(
        () => userRepository.loginUser('1234567890', 'password!123'),
      ).called(1);
      verify(() => tokenSharedPref.saveToken(token)).called(1);
      verifyNoMoreInteractions(userRepository);
      verifyNoMoreInteractions(tokenSharedPref);
    },
  );
}
