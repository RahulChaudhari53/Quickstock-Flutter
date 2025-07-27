import 'package:equatable/equatable.dart';

class VerifyOtpState extends Equatable {
  final bool isVerifying;
  final bool isResending;
  final String? errorMessage;
  final int countdown;

  const VerifyOtpState({
    this.isVerifying = false,
    this.isResending = false,
    this.errorMessage,
    this.countdown = 60,
  });

  VerifyOtpState copyWith({
    bool? isVerifying,
    bool? isResending,
    String? errorMessage,
    int? countdown,
  }) {
    return VerifyOtpState(
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      errorMessage: errorMessage ?? this.errorMessage,
      countdown: countdown ?? this.countdown,
    );
  }

  @override
  List<Object?> get props => [
    isVerifying,
    isResending,
    errorMessage,
    countdown,
  ];
}
