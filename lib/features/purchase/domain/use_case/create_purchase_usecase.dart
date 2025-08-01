import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';

class CreatePurchaseUsecase
    implements UsecaseWithParams<PurchaseEntity, CreatePurchaseParams> {
  final IPurchaseRepository repository;

  CreatePurchaseUsecase(this.repository);

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    CreatePurchaseParams params,
  ) async {
    final itemsForRepo =
        params.items
            .map(
              (item) => PurchaseItemData(
                productId: item.productId,
                quantity: item.quantity,
                unitCost: item.unitCost,
              ),
            )
            .toList();

    return await repository.createPurchase(
      supplierId: params.supplierId,
      paymentMethod: params.paymentMethod,
      items: itemsForRepo, 
      notes: params.notes,
    );
  }
}

class PurchaseCreationItem extends Equatable {
  final String productId;
  final int quantity;
  final double unitCost;

  const PurchaseCreationItem({
    required this.productId,
    required this.quantity,
    required this.unitCost,
  });

  @override
  List<Object?> get props => [productId, quantity, unitCost];
}

class CreatePurchaseParams extends Equatable {
  final String supplierId;
  final String paymentMethod;
  final List<PurchaseCreationItem> items;
  final String? notes;

  const CreatePurchaseParams({
    required this.supplierId,
    required this.paymentMethod,
    required this.items,
    this.notes,
  });

  @override
  List<Object?> get props => [supplierId, paymentMethod, items, notes];
}
