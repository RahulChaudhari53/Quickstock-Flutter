import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileInfoUsecase
    implements UsecaseWithParams<ProfileEntity, UpdateProfileInfoParams> {
  final IProfileRepository profileRepository;

  UpdateProfileInfoUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ProfileEntity>> call(
    UpdateProfileInfoParams params,
  ) async {
    return await profileRepository.updateUserInfo(
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}

class UpdateProfileInfoParams extends Equatable {
  final String firstName;
  final String lastName;

  const UpdateProfileInfoParams({
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [firstName, lastName];
}
