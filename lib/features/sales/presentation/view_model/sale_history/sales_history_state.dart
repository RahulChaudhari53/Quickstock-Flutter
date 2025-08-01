import 'package:equatable/equatable.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sale_pagination_entity.dart';

class SalesHistoryState extends Equatable {
  final List<SaleEntity> sales;
  final SalePaginationEntity? pagination;

  final bool isLoading;
  final bool isPaginating;
  final String? errorMessage;
  final Set<String>
  processingSaleIds; // To show a loader on a specific card when canceling

  final String? searchQuery;
  final String? paymentMethod;
  final String sortBy;
  final String sortOrder;

  const SalesHistoryState({
    required this.sales,
    this.pagination,
    required this.isLoading,
    required this.isPaginating,
    this.errorMessage,
    required this.processingSaleIds,
    this.searchQuery,
    this.paymentMethod,
    required this.sortBy,
    required this.sortOrder,
  });

  const SalesHistoryState.initial()
    : sales = const [],
      pagination = null,
      isLoading = true,
      isPaginating = false,
      errorMessage = null,
      processingSaleIds = const {},
      searchQuery = null,
      paymentMethod = null,
      sortBy = 'saleDate',
      sortOrder = 'desc';

  bool get hasReachedMax => pagination != null && !pagination!.hasNextPage;

  SalesHistoryState copyWith({
    List<SaleEntity>? sales,
    SalePaginationEntity? pagination,
    bool? isLoading,
    bool? isPaginating,
    String? errorMessage,
    bool clearError = false,
    Set<String>? processingSaleIds,
    String? searchQuery,
    String? paymentMethod,
    String? sortBy,
    String? sortOrder,
  }) {
    return SalesHistoryState(
      sales: sales ?? this.sales,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      processingSaleIds: processingSaleIds ?? this.processingSaleIds,
      searchQuery: searchQuery ?? this.searchQuery,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
    sales,
    pagination,
    isLoading,
    isPaginating,
    errorMessage,
    processingSaleIds,
    searchQuery,
    paymentMethod,
    sortBy,
    sortOrder,
  ];
}
