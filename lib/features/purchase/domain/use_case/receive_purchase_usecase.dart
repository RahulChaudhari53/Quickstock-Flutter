import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';

class ReceivePurchaseUsecase
    implements UsecaseWithParams<PurchaseEntity, ReceivePurchaseParams> {
  final IPurchaseRepository repository;

  ReceivePurchaseUsecase(this.repository);

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    ReceivePurchaseParams params,
  ) async {
    return await repository.receivePurchase(purchaseId: params.purchaseId);
  }
}

class ReceivePurchaseParams extends Equatable {
  final String purchaseId;

  const ReceivePurchaseParams({required this.purchaseId});

  @override
  List<Object?> get props => [purchaseId];
}
