import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/reset_password_usecase.dart';

import 'forgot_password_repository.mock.dart';

void main() {
  late ResetPasswordUseCase usecase;
  late MockForgotPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockForgotPasswordRepository();
    usecase = ResetPasswordUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const ResetPasswordParams(newPassword: '', resetToken: ''),
    );
  });

  const testParams = ResetPasswordParams(
    newPassword: 'newSecurePassword123!',
    resetToken: 'reset-token-abc',
  );

  test('should return void when password reset succeeds', () async {
    when(
      () => mockRepository.resetPassword(any(), any()),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(testParams);

    expect(result, equals(const Right(null)));
    verify(
      () => mockRepository.resetPassword(
        testParams.newPassword,
        testParams.resetToken,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when password reset fails', () async {
    final failure = RemoteDatabaseFailure(message: 'Reset failed');
    when(
      () => mockRepository.resetPassword(any(), any()),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(testParams);

    expect(result, equals(Left(failure)));
    verify(
      () => mockRepository.resetPassword(
        testParams.newPassword,
        testParams.resetToken,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
