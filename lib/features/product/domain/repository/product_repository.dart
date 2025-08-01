import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_list_view_entity.dart';

abstract interface class IProductRepository {
  Future<Either<Failure, ProductListViewEntity>> getAllProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
    String? supplierId,
    String? stockStatus,
    bool? isActive,
  });

  Future<Either<Failure, ProductEntity>> getProductById(String productId);

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
  });

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
  });

  Future<Either<Failure, ProductEntity>> deactivateProduct(String productId);

  Future<Either<Failure, ProductEntity>> activateProduct(String productId);
}
