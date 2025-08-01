import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/repository/product_repository.dart';

class UpdateProductParams extends Equatable {
  final String productId;
  final String name;
  final String categoryId;
  final String supplierId;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final int minStockLevel;
  final String? description;

  const UpdateProductParams({
    required this.productId,
    required this.name,
    required this.categoryId,
    required this.supplierId,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.minStockLevel,
    this.description,
  });

  @override
  List<Object?> get props => [
    productId,
    name,
    categoryId,
    supplierId,
    unit,
    purchasePrice,
    sellingPrice,
    minStockLevel,
    description,
  ];
}

class UpdateProductUsecase
    implements UsecaseWithParams<ProductEntity, UpdateProductParams> {
  final IProductRepository _repository;

  UpdateProductUsecase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProductEntity>> call(
    UpdateProductParams params,
  ) async {
    return await _repository.updateProduct(
      productId: params.productId,
      name: params.name,
      categoryId: params.categoryId,
      supplierId: params.supplierId,
      unit: params.unit,
      purchasePrice: params.purchasePrice,
      sellingPrice: params.sellingPrice,
      minStockLevel: params.minStockLevel,
      description: params.description,
    );
  }
}
