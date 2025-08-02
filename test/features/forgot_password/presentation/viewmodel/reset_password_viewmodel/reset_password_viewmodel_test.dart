import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/reset_password_usecase.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_event.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_state.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_viewmodel.dart';

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late ResetPasswordViewModel bloc;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUp(() {
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    bloc = ResetPasswordViewModel(mockResetPasswordUseCase);

    registerFallbackValue(
      const ResetPasswordParams(newPassword: '', resetToken: ''),
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is correct', () {
    expect(bloc.state, const ResetPasswordState());
  });

  group('PasswordChanged', () {
    blocTest<ResetPasswordViewModel, ResetPasswordState>(
      'emits state with all validation flags as true for a valid password',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordChanged('ValidPass123!')),
      expect:
          () => [
            const ResetPasswordState(
              has8Chars: true,
              hasUppercase: true,
              hasLowercase: true,
              hasNumber: true,
              hasSymbol: true,
            ),
          ],
    );

    blocTest<ResetPasswordViewModel, ResetPasswordState>(
      'emits state with has8Characters as false for a short password',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordChanged('Vp1!')),
      expect:
          () => [
            const ResetPasswordState(
              has8Chars: false,
              hasUppercase: true,
              hasLowercase: true,
              hasNumber: true,
              hasSymbol: true,
            ),
          ],
    );
  });
}
