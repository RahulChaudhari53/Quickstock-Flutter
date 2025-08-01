import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';

class UpdatePasswordUsecase
    implements UsecaseWithParams<void, UpdatePasswordParams> {
  final IProfileRepository profileRepository;

  UpdatePasswordUsecase(this.profileRepository);

  @override
  Future<Either<Failure, void>> call(UpdatePasswordParams params) async {
    return await profileRepository.updatePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}

class UpdatePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const UpdatePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
