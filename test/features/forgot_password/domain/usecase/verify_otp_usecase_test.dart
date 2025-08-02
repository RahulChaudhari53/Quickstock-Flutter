import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/verify_otp_usecase.dart';

import 'forgot_password_repository.mock.dart';

void main() {
  late VerifyOtpUseCase usecase;
  late MockForgotPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockForgotPasswordRepository();
    usecase = VerifyOtpUseCase(mockRepository);
    registerFallbackValue(const VerifyOtpParams(otp: '', tempToken: ''));
  });

  setUpAll(() {
    registerFallbackValue(const VerifyOtpParams(otp: '', tempToken: ''));
  });

  const testParams = VerifyOtpParams(
    otp: '123456',
    tempToken: 'temp-token-abc',
  );
  const resetToken = 'reset-token-xyz';

  test(
    'should return Right(resetToken) when OTP is verified successfully',
    () async {
      when(
        () => mockRepository.verifyOtp(any(), any()),
      ).thenAnswer((_) async => const Right(resetToken));

      final result = await usecase(testParams);

      expect(result, equals(const Right(resetToken)));
      verify(
        () => mockRepository.verifyOtp(testParams.otp, testParams.tempToken),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when OTP verification fails', () async {
    final failure = RemoteDatabaseFailure(message: 'OTP verification failed');
    when(
      () => mockRepository.verifyOtp(any(), any()),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(testParams);

    expect(result, equals(Left(failure)));
    verify(
      () => mockRepository.verifyOtp(testParams.otp, testParams.tempToken),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
