import 'package:equatable/equatable.dart';

class ResetPasswordState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  // flags for password validation
  final bool has8Chars;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSymbol;

  const ResetPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.has8Chars = false,
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasNumber = false,
    this.hasSymbol = false,
  });

  // helper getter to easily check if the form is valid
  bool get isPasswordValid =>
      has8Chars && hasUppercase && hasLowercase && hasNumber && hasSymbol;

  ResetPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? has8Chars,
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasNumber,
    bool? hasSymbol,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      has8Chars: has8Chars ?? this.has8Chars,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasNumber: hasNumber ?? this.hasNumber,
      hasSymbol: hasSymbol ?? this.hasSymbol,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    has8Chars,
    hasUppercase,
    hasLowercase,
    hasNumber,
    hasSymbol,
  ];
}
