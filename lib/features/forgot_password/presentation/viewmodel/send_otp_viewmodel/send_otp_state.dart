import 'package:equatable/equatable.dart';

class SendOtpState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const SendOtpState({this.isLoading = false, this.errorMessage});

  SendOtpState copyWith({bool? isLoading, String? errorMessage}) {
    return SendOtpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
