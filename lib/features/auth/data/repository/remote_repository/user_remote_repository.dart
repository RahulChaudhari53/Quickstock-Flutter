import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:quickstock/features/auth/domain/entity/user_entity.dart';
import 'package:quickstock/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository({required UserRemoteDatasource userRemoteDatasource})
    : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userRemoteDatasource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String phoneNumber,
    String password,
  ) async {
    try {
      final token = await _userRemoteDatasource.loginUser(
        phoneNumber,
        password,
      );
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
