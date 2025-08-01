import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/data/data_source/profile_data_source.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';

class ProfileRemoteRepository implements IProfileRepository {
  final IProfileDataSource remoteDataSource;

  ProfileRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profileModel = await remoteDataSource.getProfile();
      return Right(profileModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateUserInfo({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final currentProfile = await remoteDataSource.getProfile();
      final updatedProfileModel = await remoteDataSource.updateUserInfo(
        userId: currentProfile.id,
        firstName: firstName,
        lastName: lastName,
      );
      return Right(updatedProfileModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final currentProfile = await remoteDataSource.getProfile();
      await remoteDataSource.updatePassword(
        userId: currentProfile.id,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateEmail({
    required String email,
  }) async {
    try {
      final currentProfile = await remoteDataSource.getProfile();
      final updatedProfileModel = await remoteDataSource.updateEmail(
        userId: currentProfile.id,
        email: email,
      );
      return Right(updatedProfileModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfileImage({
    required File image,
  }) async {
    try {
      final currentProfile = await remoteDataSource.getProfile();
      final updatedProfileModel = await remoteDataSource.updateProfileImage(
        userId: currentProfile.id,
        image: image,
      );
      return Right(updatedProfileModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> addPhoneNumber({
    required String phoneNumber,
  }) async {
    try {
      final currentProfile = await remoteDataSource.getProfile();
      final updatedProfileModel = await remoteDataSource.addPhoneNumber(
        userId: currentProfile.id,
        phoneNumber: phoneNumber,
      );
      return Right(updatedProfileModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> deletePhoneNumber({
    required String phoneNumber,
  }) async {
    try {
      final currentProfile = await remoteDataSource.getProfile();
      final updatedProfileModel = await remoteDataSource.deletePhoneNumber(
        userId: currentProfile.id,
        phoneNumber: phoneNumber,
      );
      return Right(updatedProfileModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateAccount() async {
    try {
      final currentProfile = await remoteDataSource.getProfile();
      await remoteDataSource.deactivateAccount(userId: currentProfile.id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
