import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final bool isRefresh;
  final String? searchQuery;
  final String? categoryId;
  final String? supplierId;
  final String? stockStatus;

  const FetchProducts({
    this.isRefresh = false,
    this.searchQuery,
    this.categoryId,
    this.supplierId,
    this.stockStatus,
  });

  @override
  List<Object?> get props => [
    isRefresh,
    searchQuery,
    categoryId,
    supplierId,
    stockStatus,
  ];
}

class FetchNextPage extends ProductEvent {}

class ToggleProductStatus extends ProductEvent {
  final String productId;
  final bool currentStatus; 

  const ToggleProductStatus({
    required this.productId,
    required this.currentStatus,
  });

  @override
  List<Object> get props => [productId, currentStatus];
}
