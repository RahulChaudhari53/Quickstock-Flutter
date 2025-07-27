import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/features/auth/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late UserRegisterUsecase registerUsecase;
  late RegisterViewModel registerViewModel;

  setUp(() {
    registerUsecase = MockUserRegisterUsecase();
    registerViewModel = RegisterViewModel(registerUsecase);
    registerFallbackValue(
      RegisterUserParams(
        firstName: '',
        lastName: '',
        email: '',
        primaryPhone: '',
        password: '',
      ),
    );
    registerFallbackValue(FakeBuildContext());
  });

  group("RegisterViewModel bloc test", () {
    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success] when register succeeds',
      build: () {
        when(
          () => registerUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        return registerViewModel;
      },
      act:
          (bloc) => bloc.add(
            UserRegisterEvent(
              context: FakeBuildContext(), // Providing a fake BuildContext
              firstName: 'John',
              lastName: 'Doe',
              email: 'john@example.com',
              primaryPhone: '1234567890',
              password: 'password',
              agreedToTerms: true,
            ),
          ),
      expect:
          () => [
            const RegisterState(isLoading: true, isSuccess: false),
            const RegisterState(isLoading: false, isSuccess: true),
          ],
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, failure] when register fails',
      build: () {
        when(() => registerUsecase(any())).thenAnswer(
          (_) async =>
              Left(RemoteDatabaseFailure(message: 'Registration failed')),
        );
        return registerViewModel;
      },
      act:
          (bloc) => bloc.add(
            UserRegisterEvent(
              context: FakeBuildContext(),
              firstName: 'John',
              lastName: 'Doe',
              email: 'john@example.com',
              primaryPhone: '1234567890',
              password: 'password',
              agreedToTerms: true,
            ),
          ),
      expect:
          () => [
            const RegisterState(isLoading: true, isSuccess: false),
            const RegisterState(isLoading: false, isSuccess: false),
          ],
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits nothing when terms are not agreed',
      build: () => registerViewModel,
      act:
          (bloc) => bloc.add(
            UserRegisterEvent(
              context: FakeBuildContext(),
              firstName: 'John',
              lastName: 'Doe',
              email: 'john@example.com',
              primaryPhone: '1234567890',
              password: 'password',
              agreedToTerms: false,
            ),
          ),
      expect: () => [],
    );
  });
}
