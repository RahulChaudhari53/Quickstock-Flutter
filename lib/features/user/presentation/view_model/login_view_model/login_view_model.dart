import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:quickstock/features/user/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/user/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/features/user/presentation/view/register_view.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<NavigateToDashboardViewEvent>(_navigateToDashboardView);
    on<NavigateToRegisterViewEvent>(_navigateToRegisterView);
    on<LoginWithPhoneNumberAndPasswordEvent>(_loginWithPhoneAndPassword);
  }

  void _navigateToDashboardView(
    NavigateToDashboardViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<DashboardViewModel>(),
                child: DashboardView(),
              ),
        ),
      );
    }
  }

  void _navigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create:
                    (_) => RegisterViewModel(
                      serviceLocator<UserRegisterUsecase>(),
                    ),
                child: RegisterView(),
              ),
        ),
      );
    }
  }

  Future<void> _loginWithPhoneAndPassword(
    LoginWithPhoneNumberAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _userLoginUsecase(
      LoginUserParams(phoneNumber: event.phoneNumber, password: event.password),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: "Invalid credentials. Please try again.",
        ),
      ),
      (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }
}
