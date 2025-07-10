import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

void main() {
  late UserLoginUsecase userLoginUsecase;
  late LoginViewModel loginViewModel;

  setUp(() {
    userLoginUsecase = MockUserLoginUsecase();
    loginViewModel = LoginViewModel(userLoginUsecase);

    registerFallbackValue(LoginUserParams(phoneNumber: '', password: ''));
  });

  group('LoginViewModel tests', () {
    blocTest<LoginViewModel, LoginState>(
      "emits [loading, success] when login succeeds.",
      build: () {
        when(
          () => userLoginUsecase.call(any()),
        ).thenAnswer((_) async => Right("fake_token"));
        return loginViewModel;
      },

      act:
          (bloc) => bloc.add(
            LoginWithPhoneNumberAndPasswordEvent(
              phoneNumber: "1234567890",
              password: "password!123",
            ),
          ),
      skip: 1,
      expect:
          () => [
            LoginState(isLoading: false, isSuccess: true, errorMessage: null),
          ],
      verify: (_) {
        verify(() => userLoginUsecase.call(any())).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [loading, failure] when login fails',
      build: () {
        when(() => userLoginUsecase.call(any())).thenAnswer(
          (_) async => Left(RemoteDatabaseFailure(message: "Login Failed")),
        );
        return loginViewModel;
      },
      act:
          (bloc) => bloc.add(
            const LoginWithPhoneNumberAndPasswordEvent(
              phoneNumber: '1234567890',
              password: 'passwojriorao',
            ),
          ),
      expect:
          () => [
            const LoginState(
              isLoading: true,
              isSuccess: false,
              errorMessage: null,
            ),
            const LoginState(
              isLoading: false,
              isSuccess: false,
              errorMessage: "Invalid credentials. Please try again.",
            ),
          ],
      verify: (_) {
        verify(() => userLoginUsecase.call(any())).called(1);
      },
    );
  });
}
