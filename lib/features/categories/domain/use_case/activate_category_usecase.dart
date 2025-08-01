import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/repository/category_repository.dart';

class ActivateCategoryParams extends Equatable {
  final String categoryId;

  const ActivateCategoryParams(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class ActivateCategoryUsecase
    implements UsecaseWithParams<CategoryEntity, ActivateCategoryParams> {
  final ICategoryRepository _repository;

  ActivateCategoryUsecase({required ICategoryRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CategoryEntity>> call(
    ActivateCategoryParams params,
  ) async {
    return await _repository.activateCategory(params.categoryId);
  }
}
