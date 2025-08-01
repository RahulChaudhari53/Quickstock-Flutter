import 'package:dartz/dartz.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';

class GetProfileUsecase implements UsecaseWithoutParams<ProfileEntity> {
  final IProfileRepository profileRepository;

  GetProfileUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ProfileEntity>> call() async {
    return await profileRepository.getProfile();
  }
}
