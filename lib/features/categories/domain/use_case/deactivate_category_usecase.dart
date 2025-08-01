import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/repository/category_repository.dart';

class DeactivateCategoryParams extends Equatable {
  final String categoryId;

  const DeactivateCategoryParams(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class DeactivateCategoryUsecase
    implements UsecaseWithParams<void, DeactivateCategoryParams> {
  final ICategoryRepository _repository;

  DeactivateCategoryUsecase({required ICategoryRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeactivateCategoryParams params) async {
    return await _repository.deactivateCategory(params.categoryId);
  }
}
