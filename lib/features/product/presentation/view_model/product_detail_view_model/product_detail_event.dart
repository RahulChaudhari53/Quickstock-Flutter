// lib/features/product/presentation/event/product_detail_event.dart

import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchProductDetails extends ProductDetailEvent {
  final String productId;

  const FetchProductDetails(this.productId);

  @override
  List<Object> get props => [productId];
}

class DeactivateProductRequested extends ProductDetailEvent {
  final String productId;

  const DeactivateProductRequested(this.productId);

  @override
  List<Object> get props => [productId];
}

class ActivateProductRequested extends ProductDetailEvent {
  final String productId;

  const ActivateProductRequested(this.productId);

  @override
  List<Object> get props => [productId];
}
