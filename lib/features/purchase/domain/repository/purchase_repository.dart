import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchases_list_view_entity.dart';

class PurchaseItemData {
  final String productId;
  final int quantity;
  final double unitCost;

  PurchaseItemData({
    required this.productId,
    required this.quantity,
    required this.unitCost,
  });
}

abstract class IPurchaseRepository {
  Future<Either<Failure, PurchasesListViewEntity>> getAllPurchases({
    required int page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? supplierId,
    String? purchaseStatus,
    String? startDate,
    String? endDate,
    String? search,
  });

  Future<Either<Failure, PurchaseEntity>> getPurchaseById({
    required String purchaseId,
  });

  Future<Either<Failure, PurchaseEntity>> createPurchase({
    required String supplierId,
    required String paymentMethod,
    required List<PurchaseItemData> items,
    String? notes,
    String? purchaseNumber,
    DateTime? orderDate,
  });

  Future<Either<Failure, PurchaseEntity>> updatePurchase({
    required String purchaseId,
    String? supplierId,
    String? paymentMethod,
    List<PurchaseItemData>? items,
    String? notes,
    String? purchaseNumber,
    DateTime? orderDate,
  });

  Future<Either<Failure, void>> cancelPurchase({required String purchaseId});

  Future<Either<Failure, PurchaseEntity>> receivePurchase({
    required String purchaseId, // updates stocks
  });
}