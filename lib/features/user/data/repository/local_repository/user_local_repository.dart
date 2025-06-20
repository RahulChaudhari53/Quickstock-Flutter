import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:quickstock/features/user/domain/entity/user_entity.dart';
import 'package:quickstock/features/user/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepository({required UserLocalDataSource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, String>> loginUser(
    String phoneNumber,
    String password,
  ) async {
    try {
      final result = await _userLocalDataSource.loginUser(
        phoneNumber,
        password,
      );
      return Right(result);
    } on LocalDatabaseFailure catch (e) {
      return Left(LocalDatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        LocalDatabaseFailure(
          message: 'An unexpected error occurred during login: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return Right(null);
    } on LocalDatabaseFailure catch (e) {
      return Left(LocalDatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        LocalDatabaseFailure(
          message:
              'An unexpected error occurred during registration: ${e.toString()}',
        ),
      );
    }
  }
}
