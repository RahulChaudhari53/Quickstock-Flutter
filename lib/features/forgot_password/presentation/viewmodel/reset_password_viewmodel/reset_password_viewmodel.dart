import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/core/common/snackbar/my_snackbar.dart';
import 'package:quickstock/features/auth/presentation/view/login_view.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/reset_password_usecase.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_event.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_state.dart';

class ResetPasswordViewModel
    extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordViewModel(this._resetPasswordUseCase)
    : super(const ResetPasswordState()) {
    on<PasswordChanged>(_onPasswordChanged);
    on<ResetPasswordButtonPressed>(_onResetPasswordButtonPressed);
    on<NavigateToLogin>(_onNavigateToLogin);
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final password = event.password;
    emit(
      state.copyWith(
        has8Chars: password.length >= 8,
        hasUppercase: password.contains(RegExp(r'[A-Z]')),
        hasLowercase: password.contains(RegExp(r'[a-z]')),
        hasNumber: password.contains(RegExp(r'[0-9]')),
        hasSymbol: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    );
  }

  void _onResetPasswordButtonPressed(
    ResetPasswordButtonPressed event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        newPassword: event.newPassword,
        resetToken: event.resetToken,
      ),
    );

    result.fold(
      (failure) async {
        final errorMessage = "Failed to reset password. Please try again.";
        emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
        showMySnackBar(
          context: event.context,
          message: errorMessage,
          color: Colors.red,
        );
      },
      (_) async {
        emit(state.copyWith(isLoading: false));
        showMySnackBar(
          context: event.context,
          message: "Password has been reset successfully!",
          color: Colors.green,
        );

        Future.delayed(const Duration(seconds: 2));

        add(NavigateToLogin(event.context));
      },
    );
  }

  void _onNavigateToLogin(
    NavigateToLogin event,
    Emitter<ResetPasswordState> emit,
  ) {
    Navigator.pushAndRemoveUntil(
      event.context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create: (context) => serviceLocator<LoginViewModel>(),
              child: LoginView(),
            ),
      ),
      (route) => false,
    );
  }
}
