import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/core/common/snackbar/my_snackbar.dart';
import 'package:quickstock/features/forgot_password/presentation/view/forgot_password_view.dart';
import 'package:quickstock/features/dashboard/presentation/view/home_view.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_view_model.dart';
import 'package:quickstock/features/auth/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/auth/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/features/auth/presentation/view/register_view.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<NavigateToDashboardViewEvent>(_navigateToDashboardView);
    on<NavigateToRegisterViewEvent>(_navigateToRegisterView);
    on<LoginWithPhoneNumberAndPasswordEvent>(_loginWithPhoneAndPassword);
    on<NavigateToForgotPasswordViewEvent>(_navigateToForgotPasswordView);
  }

  void _navigateToDashboardView(
    NavigateToDashboardViewEvent event,
    Emitter<LoginState> emit,
  ) {
    try {
      if (event.context.mounted) {
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: serviceLocator<DashboardViewModel>(),
                  child: HomeView(),
                ),
          ),
        );
      }
    } catch (_) {
      // ignore in unit tests
    }
  }

  void _navigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    try {
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
    } catch (_) {
      // ignore in unit tests
    }
  }

  void _navigateToForgotPasswordView(
    NavigateToForgotPasswordViewEvent event,
    Emitter<LoginState> emit,
  ) {
    try {
      if (event.context.mounted) {
        Navigator.push(
          event.context,
          MaterialPageRoute(builder: (context) => ForgotPasswordView()),
        );
      }
    } catch (_) {
      // ignore in unit tests
    }
  }

  void _loginWithPhoneAndPassword(
    LoginWithPhoneNumberAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUsecase(
      LoginUserParams(phoneNumber: event.phoneNumber, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        try {
          showMySnackBar(
            context: event.context,
            message: "Invalid credentials. Please try again.",
            color: Colors.red[400],
          );
        } catch (_) {
          // ignore in unit tests
        }
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        try {
          add(NavigateToDashboardViewEvent(context: event.context));
        } catch (_) {
          // ignore in unit tests
        }
      },
    );
  }
}
