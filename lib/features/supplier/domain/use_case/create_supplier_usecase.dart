import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/repository/supplier_repository.dart';

class CreateSupplierParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String? notes;

  const CreateSupplierParams({
    required this.name,
    required this.email,
    required this.phone,
    this.notes,
  });

  @override
  List<Object?> get props => [name, email, phone, notes];
}

class CreateSupplierUsecase
    implements UsecaseWithParams<SupplierEntity, CreateSupplierParams> {
  final ISupplierRepository _supplierRepository;

  CreateSupplierUsecase(this._supplierRepository);

  @override
  Future<Either<Failure, SupplierEntity>> call(
    CreateSupplierParams params,
  ) async {
    return await _supplierRepository.createSupplier(
      name: params.name,
      email: params.email,
      phone: params.phone,
      notes: params.notes,
    );
  }
}
