import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_pagination_entity.dart';

class ProductState extends Equatable {
  final bool isLoading;
  final bool isPaginating;
  final List<ProductEntity> products;
  final ProductPaginationEntity? pagination;
  final String? errorMessage;
  final String? actionErrorMessage;
  final Set<String> togglingProductIds;

  final String? searchQuery;
  final String? categoryId;
  final String? supplierId;
  final String? stockStatus;

  const ProductState({
    required this.isLoading,
    required this.isPaginating,
    required this.products,
    this.pagination,
    this.errorMessage,
    this.actionErrorMessage,
    required this.togglingProductIds,
    this.searchQuery,
    this.categoryId,
    this.supplierId,
    this.stockStatus,
  });

  const ProductState.initial()
    : isLoading = false,
      isPaginating = false,
      products = const [],
      pagination = null,
      errorMessage = null,
      actionErrorMessage = null,
      togglingProductIds = const {},
      searchQuery = null,
      categoryId = null,
      supplierId = null,
      stockStatus = null;

  bool get hasReachedMax => pagination != null && !pagination!.hasNextPage;

  ProductState copyWith({
    bool? isLoading,
    bool? isPaginating,
    List<ProductEntity>? products,
    ProductPaginationEntity? pagination,
    String? errorMessage,
    String? actionErrorMessage,
    Set<String>? togglingProductIds,
    String? searchQuery,
    String? categoryId,
    String? supplierId,
    String? stockStatus,
    bool clearError = false,
    bool clearActionError = false,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      actionErrorMessage:
          clearActionError
              ? null
              : actionErrorMessage ?? this.actionErrorMessage,
      togglingProductIds: togglingProductIds ?? this.togglingProductIds,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      stockStatus: stockStatus ?? this.stockStatus,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isPaginating,
    products,
    pagination,
    errorMessage,
    actionErrorMessage,
    togglingProductIds,
    searchQuery,
    categoryId,
    supplierId,
    stockStatus,
  ];
}
