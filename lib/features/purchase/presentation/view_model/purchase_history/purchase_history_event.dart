import 'package:equatable/equatable.dart';

abstract class PurchaseHistoryEvent extends Equatable {
  const PurchaseHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialPurchases extends PurchaseHistoryEvent {}

class FetchNextPage extends PurchaseHistoryEvent {}

class FiltersApplied extends PurchaseHistoryEvent {
  final String? supplierId;
  final String? purchaseStatus;
  final String? search;
  final String? startDate;
  final String? endDate;
  final String? sortBy;
  final String? sortOrder;

  const FiltersApplied({
    this.supplierId,
    this.purchaseStatus,
    this.search,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
    supplierId,
    purchaseStatus,
    search,
    startDate,
    endDate,
    sortBy,
    sortOrder,
  ];
}
