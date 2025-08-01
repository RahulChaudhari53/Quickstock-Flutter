import 'package:dartz/dartz.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';

class DeletePhoneNumberUsecase implements UsecaseWithParams<ProfileEntity, String> {
  final IProfileRepository profileRepository;

  DeletePhoneNumberUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ProfileEntity>> call(String phoneNumber) async {
    return await profileRepository.deletePhoneNumber(phoneNumber: phoneNumber);
  }
}