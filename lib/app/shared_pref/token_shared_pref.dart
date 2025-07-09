import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPref {
  final SharedPreferences _sharedPreferences;

  TokenSharedPref({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString("token", token);
      return Right(null);
    } catch (err) {
      return Left(
        SharedPreferenceFailure(message: "Failed to save token : $err"),
      );
    }
  }

  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString("token");
      return Right(token);
    } catch (err) {
      return Left(
        SharedPreferenceFailure(message: "Failed to save token : $err"),
      );
    }
  }
}
