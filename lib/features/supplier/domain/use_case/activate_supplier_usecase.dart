import 'package:dartz/dartz.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/repository/supplier_repository.dart';

class ActivateSupplierUsecase
    implements UsecaseWithParams<SupplierEntity, String> {
  final ISupplierRepository _supplierRepository;

  ActivateSupplierUsecase(this._supplierRepository);

  @override
  Future<Either<Failure, SupplierEntity>> call(String id) async {
    return await _supplierRepository.activateSupplier(id);
  }
}
