import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileImageUsecase
    implements UsecaseWithParams<ProfileEntity, File> {
  final IProfileRepository profileRepository;

  UpdateProfileImageUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ProfileEntity>> call(File image) async {
    return await profileRepository.updateProfileImage(image: image);
  }
}
