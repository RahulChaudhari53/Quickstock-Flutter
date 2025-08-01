import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/product/data/data_source/product_data_source.dart';
import 'package:quickstock/features/product/data/dto/create_product_dto.dart';
import 'package:quickstock/features/product/data/dto/update_product_dto.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_list_view_entity.dart';
import 'package:quickstock/features/product/domain/repository/product_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final IProductDataSource _remoteDataSource;

  ProductRemoteRepository({required IProductDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ProductListViewEntity>> getAllProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
    String? supplierId,
    String? stockStatus,
    bool? isActive,
  }) async {
    try {
      final result = await _remoteDataSource.getAllProducts(
        page: page,
        limit: limit,
        search: search,
        categoryId: categoryId,
        supplierId: supplierId,
        stockStatus: stockStatus,
        isActive: isActive,
      );
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(
    String productId,
  ) async {
    try {
      final result = await _remoteDataSource.getProductById(productId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct({
    required String name,
    required String sku,
    required String categoryId,
    required String supplierId,
    required String unit,
    required double purchasePrice,
    required double sellingPrice,
    required int minStockLevel,
    String? description,
    int initialStock = 0,
  }) async {
    try {
      final dto = CreateProductDto(
        name: name,
        sku: sku,
        categoryId: categoryId,
        supplierId: supplierId,
        unit: unit,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        minStockLevel: minStockLevel,
        description: description,
        initialStock: initialStock,
      );
      final result = await _remoteDataSource.createProduct(dto);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct({
    required String productId,
    required String name,
    required String categoryId,
    required String supplierId,
    required String unit,
    required double purchasePrice,
    required double sellingPrice,
    required int minStockLevel,
    String? description,
  }) async {
    try {
      final dto = UpdateProductDto(
        name: name,
        categoryId: categoryId,
        supplierId: supplierId,
        unit: unit,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        minStockLevel: minStockLevel,
        description: description,
      );
      final result = await _remoteDataSource.updateProduct(productId, dto);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> deactivateProduct(
    String productId,
  ) async {
    try {
      final result = await _remoteDataSource.deactivateProduct(productId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> activateProduct(
    String productId,
  ) async {
    try {
      final result = await _remoteDataSource.activateProduct(productId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
