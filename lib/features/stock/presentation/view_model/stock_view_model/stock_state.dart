import 'package:equatable/equatable.dart';
import 'package:quickstock/features/stock/domain/entity/stock_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_pagination_entity.dart';

class StockState extends Equatable {
  final bool isLoading;
  final bool isPaginating;
  final List<StockEntity> stocks;
  final StockPaginationEntity? pagination;
  final String? errorMessage;

  final String? searchQuery;
  final String? stockStatus;

  const StockState({
    required this.isLoading,
    required this.isPaginating,
    required this.stocks,
    this.pagination,
    this.errorMessage,
    this.searchQuery,
    this.stockStatus,
  });

  const StockState.initial()
    : isLoading = true,
      isPaginating = false,
      stocks = const [],
      pagination = null,
      errorMessage = null,
      searchQuery = null,
      stockStatus = null;

  bool get hasReachedMax => pagination != null && !pagination!.hasNextPage;

  StockState copyWith({
    bool? isLoading,
    bool? isPaginating,
    List<StockEntity>? stocks,
    StockPaginationEntity? pagination,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
    String? stockStatus,
  }) {
    return StockState(
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      stocks: stocks ?? this.stocks,
      pagination: pagination ?? this.pagination,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      stockStatus: stockStatus ?? this.stockStatus,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isPaginating,
    stocks,
    pagination,
    errorMessage,
    searchQuery,
    stockStatus,
  ];
}
