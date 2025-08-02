import 'package:dartz/dartz.dart';
import 'package:quickstock/app/shared_pref/token_shared_pref.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';

class CheckAuthStatusUseCase implements UsecaseWithoutParams<String?> {
  final TokenSharedPref _tokenSharedPref;

  CheckAuthStatusUseCase({required TokenSharedPref tokenSharedPref})
    : _tokenSharedPref = tokenSharedPref;

  @override
  Future<Either<Failure, String?>> call() async {
    return await _tokenSharedPref.getToken();
  }
}
