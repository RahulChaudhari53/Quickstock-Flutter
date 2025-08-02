import 'package:dartz/dartz.dart';
import 'package:quickstock/app/shared_pref/token_shared_pref.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';

class LogoutUseCase implements UsecaseWithoutParams<void> {
  final TokenSharedPref _tokenSharedPref;

  LogoutUseCase({required TokenSharedPref tokenSharedPref})
    : _tokenSharedPref = tokenSharedPref;

  @override
  Future<Either<Failure, void>> call() async {
    return await _tokenSharedPref.clearToken();
  }
}
