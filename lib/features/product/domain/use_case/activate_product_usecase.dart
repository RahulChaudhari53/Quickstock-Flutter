import 'package:dartz/dartz.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/repository/product_repository.dart';

class ActivateProductUsecase
    implements UsecaseWithParams<ProductEntity, String> {
  final IProductRepository _repository;

  ActivateProductUsecase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProductEntity>> call(String productId) async {
    return await _repository.activateProduct(productId);
  }
}
