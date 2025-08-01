import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/supplier/domain/repository/supplier_repository.dart';

class GetSuppliersParams extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final bool? isActive;

  const GetSuppliersParams({
    required this.page,
    required this.limit,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.isActive,
  });

  @override
  List<Object?> get props => [page, limit, search, sortBy, sortOrder, isActive];
}

class GetSuppliersUsecase
    implements UsecaseWithParams<PaginatedSuppliers, GetSuppliersParams> {
  final ISupplierRepository _supplierRepository;

  GetSuppliersUsecase(this._supplierRepository);

  @override
  Future<Either<Failure, PaginatedSuppliers>> call(
    GetSuppliersParams params,
  ) async {
    return await _supplierRepository.getSuppliers(
      page: params.page,
      limit: params.limit,
      search: params.search,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
      isActive: params.isActive,
    );
  }
}
