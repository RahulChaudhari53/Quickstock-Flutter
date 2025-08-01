import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';
import 'package:quickstock/features/purchase/domain/use_case/create_purchase_usecase.dart';

class UpdatePurchaseUsecase
    implements UsecaseWithParams<PurchaseEntity, UpdatePurchaseParams> {
  final IPurchaseRepository repository;

  UpdatePurchaseUsecase(this.repository);

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    UpdatePurchaseParams params,
  ) async {
    final List<PurchaseItemData>? itemsForRepo;
    if (params.items != null) {
      itemsForRepo =
          params.items!
              .map(
                (item) => PurchaseItemData(
                  productId: item.productId,
                  quantity: item.quantity,
                  unitCost: item.unitCost,
                ),
              )
              .toList();
    } else {
      itemsForRepo = null;
    }

    return await repository.updatePurchase(
      purchaseId: params.purchaseId,
      supplierId: params.supplierId,
      paymentMethod: params.paymentMethod,
      items: itemsForRepo,
      notes: params.notes,
    );
  }
}

class UpdatePurchaseParams extends Equatable {
  final String purchaseId; 
  final String? supplierId;
  final String? paymentMethod;
  final List<PurchaseCreationItem>? items;
  final String? notes;

  const UpdatePurchaseParams({
    required this.purchaseId,
    this.supplierId,
    this.paymentMethod,
    this.items,
    this.notes,
  });

  @override
  List<Object?> get props => [
    purchaseId,
    supplierId,
    paymentMethod,
    items,
    notes,
  ];
}
