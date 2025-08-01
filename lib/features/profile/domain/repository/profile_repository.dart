import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, ProfileEntity>> updateUserInfo({
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, void>> updatePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either<Failure, ProfileEntity>> updateEmail({required String email});

  Future<Either<Failure, ProfileEntity>> updateProfileImage({
    required File image,
  });

  Future<Either<Failure, ProfileEntity>> addPhoneNumber({
    required String phoneNumber,
  });

  Future<Either<Failure, ProfileEntity>> deletePhoneNumber({
    required String phoneNumber,
  });

  Future<Either<Failure, void>> deactivateAccount();
}
