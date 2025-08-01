import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/entity/pagination_info_entity.dart';

// wrapper class to hold both pieces of paginated data.
class PaginatedCategories {
  final List<CategoryEntity> categories;
  final PaginationInfoEntity paginationInfo;

  PaginatedCategories({required this.categories, required this.paginationInfo});
}

abstract interface class ICategoryRepository {
  // fetch a paginated list of categories.
  Future<Either<Failure, PaginatedCategories>> getAllCategories({
    required int page,
    int? limit,
    String? searchTerm,
    String? sortBy,
    bool? isActive,
  });

  Future<Either<Failure, CategoryEntity>> createCategory({
    required String name,
    String? description,
  });

  Future<Either<Failure, void>> deactivateCategory(String categoryId);

  Future<Either<Failure, CategoryEntity>> activateCategory(String categoryId);
}
