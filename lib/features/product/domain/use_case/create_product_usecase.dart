import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/repository/product_repository.dart';

class CreateProductParams extends Equatable {
  final String name;
  final String sku;
  final String categoryId;
  final String supplierId;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final int minStockLevel;
  final String? description;
  final int initialStock;

  const CreateProductParams({
    required this.name,
    required this.sku,
    required this.categoryId,
    required this.supplierId,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.minStockLevel,
    this.description,
    this.initialStock = 0,
  });

  @override
  List<Object?> get props => [
    name,
    sku,
    categoryId,
    supplierId,
    unit,
    purchasePrice,
    sellingPrice,
    minStockLevel,
    description,
    initialStock,
  ];
}

class CreateProductUsecase
    implements UsecaseWithParams<ProductEntity, CreateProductParams> {
  final IProductRepository _repository;

  CreateProductUsecase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProductEntity>> call(
    CreateProductParams params,
  ) async {
    return await _repository.createProduct(
      name: params.name,
      sku: params.sku,
      categoryId: params.categoryId,
      supplierId: params.supplierId,
      unit: params.unit,
      purchasePrice: params.purchasePrice,
      sellingPrice: params.sellingPrice,
      minStockLevel: params.minStockLevel,
      description: params.description,
      initialStock: params.initialStock,
    );
  }
}
