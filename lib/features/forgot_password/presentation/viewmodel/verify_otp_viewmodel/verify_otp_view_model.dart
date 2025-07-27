import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/core/common/snackbar/my_snackbar.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/send_otp_usecase.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/verify_otp_usecase.dart';
import 'package:quickstock/features/forgot_password/presentation/view/reset_password_view.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_viewmodel.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_event.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_state.dart';

class VerifyOtpViewModel extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase; // for resending
  Timer? _timer;

  VerifyOtpViewModel(this._verifyOtpUseCase, this._sendOtpUseCase)
    : super(const VerifyOtpState()) {
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<NavigateToResetPassword>(_onNavigateToResetPassword);
    on<TimerTicked>(_onTimerTicked);

    _startTimer(); // timer is started when bloc is created
  }

  void _startTimer() {
    _timer?.cancel();
    add(TimerTicked(60));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        add(TimerTicked(state.countdown - 1));
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onTimerTicked(TimerTicked event, Emitter<VerifyOtpState> emit) {
    emit(state.copyWith(countdown: event.newTime));
  }

  void _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(state.copyWith(isVerifying: true, errorMessage: null));
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(otp: event.otp, tempToken: event.tempToken),
    );

    result.fold(
      (failure) {
        final errorMessage = "Invalid or expired OTP.";
        emit(state.copyWith(isVerifying: false, errorMessage: errorMessage));
        showMySnackBar(
          context: event.context,
          message: errorMessage,
          color: Colors.red,
        );
      },
      (resetToken) {
        emit(state.copyWith(isVerifying: false));
        add(
          NavigateToResetPassword(
            context: event.context,
            resetToken: resetToken,
          ),
        );
      },
    );
  }

  void _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(state.copyWith(isResending: true, errorMessage: null));
    final result = await _sendOtpUseCase(SendOtpParams(event.email));

    result.fold(
      (failure) {
        emit(state.copyWith(isResending: false));
        showMySnackBar(
          context: event.context,
          message: "Failed to resend OTP",
          color: Colors.red,
        );
      },
      (_) {
        emit(state.copyWith(isResending: false));
        showMySnackBar(
          context: event.context,
          message: "A new OTP has been sent.",
          color: Colors.green,
        );
        _startTimer(); // restart the timer on successful resend
      },
    );
  }

  void _onNavigateToResetPassword(
    NavigateToResetPassword event,
    Emitter<VerifyOtpState> emit,
  ) {
    Navigator.pushReplacement(
      event.context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create:
                  (context) =>
                      serviceLocator<
                        ResetPasswordViewModel
                      >(),
              child: ResetPasswordView(resetToken: event.resetToken),
            ),
      ),
    );
  }
}
