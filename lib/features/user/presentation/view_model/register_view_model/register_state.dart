class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
  });

  const RegisterState.initial()
    : isLoading = false,
      isSuccess = false,
      errorMessage = null;

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}
