import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;

  const RegisterState({required this.isLoading, required this.isSuccess});

  const RegisterState.initial() : this(isLoading: false, isSuccess: false);

  RegisterState copyWith({bool? isLoading, bool? isSuccess}) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess];
}
