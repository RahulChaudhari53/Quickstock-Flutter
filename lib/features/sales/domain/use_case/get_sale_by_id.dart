import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/repository/sale_repository.dart';

class GetSaleByIdParams extends Equatable {
  final String saleId;

  const GetSaleByIdParams({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

class GetSaleByIdUsecase
    implements UsecaseWithParams<SaleEntity, GetSaleByIdParams> {
  final ISaleRepository _repository;

  GetSaleByIdUsecase({required ISaleRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, SaleEntity>> call(GetSaleByIdParams params) async {
    return await _repository.getSaleById(saleId: params.saleId);
  }
}
