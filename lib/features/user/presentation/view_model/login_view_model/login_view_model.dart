import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/user/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<LoginWithPhoneNumberAndPasswordEvent>(_loginWithPhoneAndPassword);
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
