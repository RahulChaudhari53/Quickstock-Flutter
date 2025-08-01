import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/data/data_source/category_data_source.dart';
import 'package:quickstock/features/categories/data/dto/create_category_dto.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/repository/category_repository.dart';

class CategoryRemoteRepository implements ICategoryRepository {
  final ICategoryDataSource _remoteDataSource;

  CategoryRemoteRepository({required ICategoryDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, PaginatedCategories>> getAllCategories({
    required int page,
    int? limit,
    String? searchTerm,
    String? sortBy,
    bool? isActive,
  }) async {
    try {
      final dto = await _remoteDataSource.getAllCategories(
        page: page,
        limit: limit,
        searchTerm: searchTerm,
        sortBy: sortBy,
        isActive: isActive,
      );

      final categories =
          dto.categories.map((model) => model.toEntity()).toList();
      final paginationInfo = dto.pagination.toEntity();

      return Right(
        PaginatedCategories(
          categories: categories,
          paginationInfo: paginationInfo,
        ),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      final dto = CreateCategoryDto(name: name, description: description);
      final model = await _remoteDataSource.createCategory(dto);
      return Right(model.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateCategory(String categoryId) async {
    try {
      await _remoteDataSource.deactivateCategory(categoryId);
      return const Right(null); // Return Right with void (represented as null)
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> activateCategory(
    String categoryId,
  ) async {
    try {
      final model = await _remoteDataSource.activateCategory(categoryId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
