import 'package:equatable/equatable.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_pagination_entity.dart';

class StockHistoryState extends Equatable {
  final String? productId;
  final bool isLoading;
  final bool isPaginating;
  final List<StockHistoryEntity> history;
  final StockPaginationEntity? pagination;
  final String? errorMessage;

  const StockHistoryState({
    this.productId,
    required this.isLoading,
    required this.isPaginating,
    required this.history,
    this.pagination,
    this.errorMessage,
  });

  const StockHistoryState.initial()
    : productId = null,
      isLoading = true,
      isPaginating = false,
      history = const [],
      pagination = null,
      errorMessage = null;

  bool get hasReachedMax => pagination != null && !pagination!.hasNextPage;

  StockHistoryState copyWith({
    String? productId,
    bool? isLoading,
    bool? isPaginating,
    List<StockHistoryEntity>? history,
    StockPaginationEntity? pagination,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StockHistoryState(
      productId: productId ?? this.productId,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      history: history ?? this.history,
      pagination: pagination ?? this.pagination,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    isLoading,
    isPaginating,
    history,
    pagination,
    errorMessage,
  ];
}
