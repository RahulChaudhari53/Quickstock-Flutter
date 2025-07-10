import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_state.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_view_model.dart';

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

void main() {
  late MockUserRegisterUsecase userRegisterUsecase;
  late RegisterViewModel registerViewModel;

  setUp(() {
    userRegisterUsecase = MockUserRegisterUsecase();
    registerViewModel = RegisterViewModel(userRegisterUsecase);
    registerFallbackValue(
      RegisterUserParams(
        firstName: '',
        lastName: '',
        email: '',
        primaryPhone: '',
        password: '',
      ),
    );
  });

  group('RegisterViewModel Tests', () {
    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success] when register usecase succeeds',
      build: () {
        when(
          () => userRegisterUsecase.call(any()),
        ).thenAnswer((_) async => Right(null));
        return registerViewModel;
      },
      act:
          (bloc) => bloc.add(
            UserRegisterEvent(
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
      verify: (_) {
        verify(() => userRegisterUsecase.call(any())).called(1);
      },
    );
    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, failure] when register usecase fails',
      build: () {
        when(() => userRegisterUsecase.call(any())).thenAnswer(
          (_) async =>
              Left(RemoteDatabaseFailure(message: 'Registration failed')),
        );
        return registerViewModel;
      },
      act:
          (bloc) => bloc.add(
            UserRegisterEvent(
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
            const RegisterState(
              isLoading: false,
              isSuccess: false,
              errorMessage: 'Registration failed',
            ),
          ],
      verify: (_) {
        verify(() => userRegisterUsecase.call(any())).called(1);
      },
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits failure without loading if terms not agreed',
      build: () => registerViewModel,
      act:
          (bloc) => bloc.add(
            UserRegisterEvent(
              firstName: 'John',
              lastName: 'Doe',
              email: 'john@example.com',
              primaryPhone: '1234567890',
              password: 'password',
              agreedToTerms: false,
            ),
          ),
      expect:
          () => [
            const RegisterState(
              isLoading: false,
              isSuccess: false,
              errorMessage: "You must agree to the privacy policy and terms.",
            ),
          ],
      verify: (_) {
        verifyNever(() => userRegisterUsecase.call(any()));
      },
    );
  });
}
