import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_pagination_info_entity.dart';

class PaginatedSuppliers {
  final List<SupplierEntity> suppliers;
  final SupplierPaginationInfoEntity paginationInfo;

  PaginatedSuppliers({required this.suppliers, required this.paginationInfo});
}

abstract interface class ISupplierRepository {
  Future<Either<Failure, PaginatedSuppliers>> getSuppliers({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
    bool? isActive,
  });

  Future<Either<Failure, SupplierEntity>> getSupplierById(String id);

  Future<Either<Failure, SupplierEntity>> createSupplier({
    required String name,
    required String email,
    required String phone,
    String? notes,
  });

  Future<Either<Failure, SupplierEntity>> updateSupplier({
    required String id,
    String? name,
    String? email,
    String? phone,
    String? notes,
  });

  Future<Either<Failure, SupplierEntity>> deactivateSupplier(String id);

  Future<Either<Failure, SupplierEntity>> activateSupplier(String id);
}
