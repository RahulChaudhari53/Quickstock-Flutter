import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/core/common/snackbar/my_snackbar.dart';
import 'package:quickstock/features/user/domain/usecase/user_register_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUsecase _userRegisterUsecase;

  RegisterViewModel(this._userRegisterUsecase)
    : super(const RegisterState.initial()) {
    on<UserRegisterEvent>(_onUserRegister);
  }

  Future<void> _onUserRegister(
    UserRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    if (!event.agreedToTerms) {
      showMySnackBar(
        context: event.context,
        message: "You must agree to the privacy policy and terms.",
        color: Colors.red[400],
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUsecase(
      RegisterUserParams(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phoneNumbers: [event.phoneNumber],
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Successful signup. Please login.",
          color: Colors.green[400],
        );
        Navigator.pop(event.context);
      },
    );
  }
}
