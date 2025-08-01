import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/repository/supplier_repository.dart';

class UpdateSupplierParams extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? notes;

  const UpdateSupplierParams({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.notes,
  });

  @override
  List<Object?> get props => [id, name, email, phone, notes];
}

class UpdateSupplierUsecase
    implements UsecaseWithParams<SupplierEntity, UpdateSupplierParams> {
  final ISupplierRepository _supplierRepository;

  UpdateSupplierUsecase(this._supplierRepository);

  @override
  Future<Either<Failure, SupplierEntity>> call(
    UpdateSupplierParams params,
  ) async {
    return await _supplierRepository.updateSupplier(
      id: params.id,
      name: params.name,
      email: params.email,
      phone: params.phone,
      notes: params.notes,
    );
  }
}
