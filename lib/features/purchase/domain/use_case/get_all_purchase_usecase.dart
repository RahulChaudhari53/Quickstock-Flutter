import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/purchase/domain/entity/purchases_list_view_entity.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';

class GetAllPurchasesUsecase
    implements
        UsecaseWithParams<PurchasesListViewEntity, GetAllPurchasesParams> {
  final IPurchaseRepository repository;

  GetAllPurchasesUsecase(this.repository);

  @override
  Future<Either<Failure, PurchasesListViewEntity>> call(
    GetAllPurchasesParams params,
  ) async {
    return await repository.getAllPurchases(
      page: params.page,
      limit: params.limit,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
      supplierId: params.supplierId,
      purchaseStatus: params.purchaseStatus,
      startDate: params.startDate,
      endDate: params.endDate,
      search: params.search,
    );
  }
}

class GetAllPurchasesParams extends Equatable {
  final int page;
  final int? limit;
  final String? sortBy;
  final String? sortOrder;
  final String? supplierId;
  final String? purchaseStatus;
  final String? startDate;
  final String? endDate;
  final String? search;

  const GetAllPurchasesParams({
    required this.page,
    this.limit,
    this.sortBy,
    this.sortOrder,
    this.supplierId,
    this.purchaseStatus,
    this.startDate,
    this.endDate,
    this.search,
  });

  @override
  List<Object?> get props => [
    page,
    limit,
    sortBy,
    sortOrder,
    supplierId,
    purchaseStatus,
    startDate,
    endDate,
    search,
  ];
}
