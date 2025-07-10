import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class FakeLoginUserParams extends Fake implements LoginUserParams {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockUserLoginUsecase mockLoginUsecase;
  late LoginViewModel loginViewModel;

  setUp(() {
    mockLoginUsecase = MockUserLoginUsecase();
    loginViewModel = LoginViewModel(mockLoginUsecase);
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(FakeLoginUserParams());
  });

  group("LoginViewModel bloc test", () {
    blocTest<LoginViewModel, LoginState>(
      'emits [loading, success] when login succeeds',
      build: () {
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => Right('fake-token'));
        return loginViewModel;
      },
      act:
          (bloc) => bloc.add(
            LoginWithPhoneNumberAndPasswordEvent(
              context: FakeBuildContext(),
              phoneNumber: '1234567890',
              password: 'password123',
            ),
          ),
      skip: 1,
      expect: () => [LoginState(isLoading: false, isSuccess: true)],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [loading, failure] when login fails',
      build: () {
        when(() => mockLoginUsecase(any())).thenAnswer(
          (_) async =>
              Left(RemoteDatabaseFailure(message: 'Invalid credentials')),
        );
        return loginViewModel;
      },
      act:
          (bloc) => bloc.add(
            LoginWithPhoneNumberAndPasswordEvent(
              context: FakeBuildContext(),
              phoneNumber: '1234567890',
              password: 'passeord error',
            ),
          ),
      skip: 1,
      expect: () => [LoginState(isLoading: false, isSuccess: false)],
    );
  });
}
