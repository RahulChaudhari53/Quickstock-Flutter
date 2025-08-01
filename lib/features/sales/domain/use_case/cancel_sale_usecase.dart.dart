import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/sales/domain/repository/sale_repository.dart';

class CancelSaleParams extends Equatable {
  final String saleId;

  const CancelSaleParams({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

class CancelSaleUsecase implements UsecaseWithParams<void, CancelSaleParams> {
  final ISaleRepository _repository;

  CancelSaleUsecase({required ISaleRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(CancelSaleParams params) async {
    return await _repository.cancelSale(saleId: params.saleId);
  }
}
