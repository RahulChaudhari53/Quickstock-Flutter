import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/send_otp_usecase.dart';

import 'forgot_password_repository.mock.dart';

void main() {
  late SendOtpUseCase usecase;
  late MockForgotPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockForgotPasswordRepository();
    usecase = SendOtpUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const SendOtpParams(''));
  });

  const testParams = SendOtpParams('test@example.com');
  const tempToken = 'temp-token-123';

  test(
    'should return Right(tempToken) when OTP is sent successfully',
    () async {
      when(
        () => mockRepository.sendOtp(any()),
      ).thenAnswer((_) async => const Right(tempToken));

      final result = await usecase(testParams);

      expect(result, equals(const Right(tempToken)));
      verify(() => mockRepository.sendOtp(testParams.email)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return failure when sending OTP fails', () async {
    final failure = RemoteDatabaseFailure(message: 'Failed to send OTP');
    when(
      () => mockRepository.sendOtp(any()),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(testParams);

    expect(result, equals(Left(failure)));
    verify(() => mockRepository.sendOtp(testParams.email)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
