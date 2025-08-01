import 'package:quickstock/features/purchase/data/dto/create_purchase_dto.dart';
import 'package:quickstock/features/purchase/data/dto/update_purchase_dto.dart';
import 'package:quickstock/features/purchase/data/model/purchase_api_model.dart';

abstract class IPurchaseDataSource {
  Future<PurchasesListViewApiModel> getAllPurchases({
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

  Future<PurchaseApiModel> getPurchaseById({required String purchaseId});

  Future<PurchaseApiModel> createPurchase({
    required CreatePurchaseDto createPurchaseDto,
  });

  Future<PurchaseApiModel> updatePurchase({
    required String purchaseId,
    required UpdatePurchaseDto updatePurchaseDto,
  });

  Future<void> cancelPurchase({required String purchaseId});

  Future<PurchaseApiModel> receivePurchase({required String purchaseId});
}
