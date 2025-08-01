import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';

class GetPurchaseByIdUsecase
    implements UsecaseWithParams<PurchaseEntity, GetPurchaseByIdParams> {
  final IPurchaseRepository repository;

  GetPurchaseByIdUsecase(this.repository);

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    GetPurchaseByIdParams params,
  ) async {
    return await repository.getPurchaseById(purchaseId: params.purchaseId);
  }
}

class GetPurchaseByIdParams extends Equatable {
  final String purchaseId;

  const GetPurchaseByIdParams({required this.purchaseId});

  @override
  List<Object?> get props => [purchaseId];
}
