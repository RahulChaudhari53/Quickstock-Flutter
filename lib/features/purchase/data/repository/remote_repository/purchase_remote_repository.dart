import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/data/data_source/purchase_data_source.dart';
import 'package:quickstock/features/purchase/data/dto/create_purchase_dto.dart';
import 'package:quickstock/features/purchase/data/dto/update_purchase_dto.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchases_list_view_entity.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';

class PurchaseRemoteRepository implements IPurchaseRepository {
  final IPurchaseDataSource remoteDataSource;

  PurchaseRemoteRepository({required this.remoteDataSource});

  @override
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
  }) async {
    try {
      final remotePurchases = await remoteDataSource.getAllPurchases(
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        supplierId: supplierId,
        purchaseStatus: purchaseStatus,
        startDate: startDate,
        endDate: endDate,
        search: search,
      );
      return Right(remotePurchases.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> getPurchaseById({
    required String purchaseId,
  }) async {
    try {
      final remotePurchase = await remoteDataSource.getPurchaseById(
        purchaseId: purchaseId,
      );
      return Right(remotePurchase.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> createPurchase({
    required String supplierId,
    required String paymentMethod,
    required List<PurchaseItemData> items,
    String? notes,
    String? purchaseNumber,
    DateTime? orderDate,
  }) async {
    final createPurchaseDto = CreatePurchaseDto(
      supplier: supplierId,
      paymentMethod: paymentMethod,
      notes: notes,
      purchaseNumber: purchaseNumber,
      orderDate: orderDate,
      items:
          items
              .map(
                (item) => CreatePurchaseItemDto(
                  product: item.productId,
                  quantity: item.quantity,
                  // The backend calculates totalCost, but your model requires unitCost
                  // Assuming your backend can handle just unitCost and derive totalCost
                  unitCost: item.unitCost,
                ),
              )
              .toList(),
    );

    try {
      final remotePurchase = await remoteDataSource.createPurchase(
        createPurchaseDto: createPurchaseDto,
      );
      return Right(remotePurchase.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> updatePurchase({
    required String purchaseId,
    String? supplierId,
    String? paymentMethod,
    List<PurchaseItemData>? items,
    String? notes,
    String? purchaseNumber,
    DateTime? orderDate,
  }) async {
    final updatePurchaseDto = UpdatePurchaseDto(
      supplier: supplierId,
      paymentMethod: paymentMethod,
      notes: notes,
      purchaseNumber: purchaseNumber,
      orderDate: orderDate,
      items:
          items
              ?.map(
                (item) => CreatePurchaseItemDto(
                  product: item.productId,
                  quantity: item.quantity,
                  unitCost: item.unitCost,
                ),
              )
              .toList(),
    );

    try {
      final remotePurchase = await remoteDataSource.updatePurchase(
        purchaseId: purchaseId,
        updatePurchaseDto: updatePurchaseDto,
      );
      return Right(remotePurchase.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelPurchase({
    required String purchaseId,
  }) async {
    try {
      await remoteDataSource.cancelPurchase(purchaseId: purchaseId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> receivePurchase({
    required String purchaseId,
  }) async {
    try {
      final remotePurchase = await remoteDataSource.receivePurchase(
        purchaseId: purchaseId,
      );
      return Right(remotePurchase.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
