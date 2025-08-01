import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/supplier/data/data_source/supplier_data_source.dart';
import 'package:quickstock/features/supplier/data/dto/create_supplier_dto.dart';
import 'package:quickstock/features/supplier/data/dto/update_supplier_dto.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/repository/supplier_repository.dart';

class SupplierRemoteRepository implements ISupplierRepository {
  final ISupplierDataSource _remoteDataSource;

  SupplierRemoteRepository({required ISupplierDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, PaginatedSuppliers>> getSuppliers({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
    bool? isActive,
  }) async {
    try {
      final dto = await _remoteDataSource.getSuppliers(
        page: page,
        limit: limit,
        search: search,
        sortBy: sortBy,
        sortOrder: sortOrder,
        isActive: isActive,
      );

      final suppliers = dto.suppliers.map((model) => model.toEntity()).toList();
      final paginationInfo = dto.pagination.toEntity();

      final paginatedData = PaginatedSuppliers(
        suppliers: suppliers,
        paginationInfo: paginationInfo,
      );

      return Right(paginatedData);
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> createSupplier({
    required String name,
    required String email,
    required String phone,
    String? notes,
  }) async {
    try {
      final dto = CreateSupplierDto(
        name: name,
        email: email,
        phone: phone,
        notes: notes,
      );
      final supplierModel = await _remoteDataSource.createSupplier(dto);
      return Right(supplierModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> getSupplierById(String id) async {
    try {
      final supplierModel = await _remoteDataSource.getSupplierById(id);
      return Right(supplierModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> updateSupplier({
    required String id,
    String? name,
    String? email,
    String? phone,
    String? notes,
  }) async {
    try {
      final dto = UpdateSupplierDto(
        name: name,
        email: email,
        phone: phone,
        notes: notes,
      );
      final supplierModel = await _remoteDataSource.updateSupplier(id, dto);
      return Right(supplierModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> deactivateSupplier(String id) async {
    try {
      final supplierModel = await _remoteDataSource.deactivateSupplier(id);
      return Right(supplierModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> activateSupplier(String id) async {
    try {
      final supplierModel = await _remoteDataSource.activateSupplier(id);
      return Right(supplierModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
