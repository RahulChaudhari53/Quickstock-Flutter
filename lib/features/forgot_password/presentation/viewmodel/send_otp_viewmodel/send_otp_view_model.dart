import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/core/common/snackbar/my_snackbar.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/send_otp_usecase.dart';
import 'package:quickstock/features/forgot_password/presentation/view/verify_otp_view.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/send_otp_viewmodel/send_otp_event.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/send_otp_viewmodel/send_otp_state.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_view_model.dart';

class SendOtpViewModel extends Bloc<SendOtpEvent, SendOtpState> {
  final SendOtpUseCase _sendOtpUseCase;

  SendOtpViewModel(this._sendOtpUseCase) : super(const SendOtpState()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<NavigateToVerifyOtp>(_onNavigateToVerifyOtp);
  }

  void _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<SendOtpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _sendOtpUseCase(SendOtpParams(event.email));

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Failed to send OTP. Please try again.",
          ),
        );
        showMySnackBar(
          context: event.context,
          message: "Failed to send OTP. Please try again.",
          color: Colors.red,
        );
      },
      (tempToken) {
        emit(state.copyWith(isLoading: false));
        showMySnackBar(
          context: event.context,
          message: "Verification code sent to ${event.email}",
          color: Colors.green,
        );
        add(
          NavigateToVerifyOtp(
            context: event.context,
            email: event.email,
            tempToken: tempToken,
          ),
        );
      },
    );
  }

  void _onNavigateToVerifyOtp(
    NavigateToVerifyOtp event,
    Emitter<SendOtpState> emit,
  ) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create: (context) => serviceLocator<VerifyOtpViewModel>(),
              child: VerifyOtpView(
                email: event.email,
                tempToken: event.tempToken,
              ),
            ),
      ),
    );
  }
}
