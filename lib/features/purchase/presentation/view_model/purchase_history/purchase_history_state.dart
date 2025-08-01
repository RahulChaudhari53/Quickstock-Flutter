import 'package:equatable/equatable.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';

enum PurchaseHistoryStatus { initial, loading, success, failure, loadingNextPage }

class PurchaseHistoryState extends Equatable {
  final PurchaseHistoryStatus status;
  final List<PurchaseEntity> purchases;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;
  final String? selectedSupplierId;
  final String? selectedPurchaseStatus;
  final String? searchTerm;
  final String? selectedStartDate;
  final String? selectedEndDate;
  final String? selectedSortBy;
  final String? selectedSortOrder;

  const PurchaseHistoryState({
    this.status = PurchaseHistoryStatus.initial,
    this.purchases = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.selectedSupplierId,
    this.selectedPurchaseStatus,
    this.searchTerm,
    this.selectedStartDate,
    this.selectedEndDate,
    this.selectedSortBy,
    this.selectedSortOrder,
  });

  PurchaseHistoryState copyWith({
    PurchaseHistoryStatus? status,
    List<PurchaseEntity>? purchases,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    String? selectedSupplierId,
    String? selectedPurchaseStatus,
    String? searchTerm,
    String? selectedStartDate,
    String? selectedEndDate,
    String? selectedSortBy,
    String? selectedSortOrder,
  }) {
    return PurchaseHistoryState(
      status: status ?? this.status,
      purchases: purchases ?? this.purchases,
      errorMessage: (status == PurchaseHistoryStatus.success || status == PurchaseHistoryStatus.loading) ? null : errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedSupplierId: selectedSupplierId ?? this.selectedSupplierId,
      selectedPurchaseStatus: selectedPurchaseStatus ?? this.selectedPurchaseStatus,
      searchTerm: searchTerm ?? this.searchTerm,
      selectedStartDate: selectedStartDate ?? this.selectedStartDate,
      selectedEndDate: selectedEndDate ?? this.selectedEndDate,
      selectedSortBy: selectedSortBy ?? this.selectedSortBy,
      selectedSortOrder: selectedSortOrder ?? this.selectedSortOrder,
    );
  }

  @override
  List<Object?> get props => [
        status,
        purchases,
        errorMessage,
        currentPage,
        hasReachedMax,
        selectedSupplierId,
        selectedPurchaseStatus,
        searchTerm,
        selectedStartDate,
        selectedEndDate,
        selectedSortBy,
        selectedSortOrder,
      ];
}