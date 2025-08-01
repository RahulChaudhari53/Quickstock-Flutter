import 'package:dartz/dartz.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';

class DeactivateAccountUsecase implements UsecaseWithoutParams<void> {
  final IProfileRepository profileRepository;

  DeactivateAccountUsecase(this.profileRepository);

  @override
  Future<Either<Failure, void>> call() async {
    return await profileRepository.deactivateAccount();
  }
}
