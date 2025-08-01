import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';

class CancelPurchaseUsecase
    implements UsecaseWithParams<void, CancelPurchaseParams> {
  final IPurchaseRepository repository;

  CancelPurchaseUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelPurchaseParams params) async {
    return await repository.cancelPurchase(purchaseId: params.purchaseId);
  }
}

class CancelPurchaseParams extends Equatable {
  final String purchaseId;

  const CancelPurchaseParams({required this.purchaseId});

  @override
  List<Object?> get props => [purchaseId];
}