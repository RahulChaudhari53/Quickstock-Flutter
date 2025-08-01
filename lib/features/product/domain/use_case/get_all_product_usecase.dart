import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/product/domain/entity/product_list_view_entity.dart';
import 'package:quickstock/features/product/domain/repository/product_repository.dart';

class GetAllProductsParams extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final String? categoryId;
  final String? supplierId;
  final String? stockStatus;
  final bool? isActive;

  const GetAllProductsParams({
    required this.page,
    this.limit = 15,
    this.search,
    this.categoryId,
    this.supplierId,
    this.stockStatus,
    this.isActive,
  });

  @override
  List<Object?> get props => [
    page,
    limit,
    search,
    categoryId,
    supplierId,
    stockStatus,
    isActive,
  ];
}

class GetAllProductsUsecase
    implements UsecaseWithParams<ProductListViewEntity, GetAllProductsParams> {
  final IProductRepository _repository;

  GetAllProductsUsecase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProductListViewEntity>> call(
    GetAllProductsParams params,
  ) async {
    return await _repository.getAllProducts(
      page: params.page,
      limit: params.limit,
      search: params.search,
      categoryId: params.categoryId,
      supplierId: params.supplierId,
      stockStatus: params.stockStatus,
      isActive: params.isActive,
    );
  }
}
