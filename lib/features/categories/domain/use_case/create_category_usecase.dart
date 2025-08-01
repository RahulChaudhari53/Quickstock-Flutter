import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/repository/category_repository.dart';

class CreateCategoryParams extends Equatable {
  final String name;
  final String? description;

  const CreateCategoryParams({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class CreateCategoryUsecase
    implements UsecaseWithParams<CategoryEntity, CreateCategoryParams> {
  final ICategoryRepository _repository;

  CreateCategoryUsecase({required ICategoryRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CategoryEntity>> call(
    CreateCategoryParams params,
  ) async {
    return await _repository.createCategory(
      name: params.name,
      description: params.description,
    );
  }
}
