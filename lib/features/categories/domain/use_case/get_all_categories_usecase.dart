import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/repository/category_repository.dart';

class GetAllCategoriesParams extends Equatable {
  final int page;
  final int? limit;
  final String? searchTerm;
  final String? sortBy;
  final bool? isActive;

  const GetAllCategoriesParams({
    required this.page,
    this.limit,
    this.searchTerm,
    this.sortBy,
    this.isActive,
  });

  @override
  List<Object?> get props => [page, limit, searchTerm, sortBy, isActive];
}

class GetAllCategoriesUsecase
    implements UsecaseWithParams<PaginatedCategories, GetAllCategoriesParams> {
  final ICategoryRepository _repository;

  GetAllCategoriesUsecase({required ICategoryRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, PaginatedCategories>> call(
    GetAllCategoriesParams params,
  ) async {
    return await _repository.getAllCategories(
      page: params.page,
      limit: params.limit,
      searchTerm: params.searchTerm,
      sortBy: params.sortBy,
      isActive: params.isActive,
    );
  }
}
