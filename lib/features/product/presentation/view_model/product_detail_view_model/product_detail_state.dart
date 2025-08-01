import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';

class ProductDetailState extends Equatable {
  final bool isLoading;
  final ProductEntity? product;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const ProductDetailState({
    required this.isLoading,
    this.product,
    required this.isSubmitting,
    this.errorMessage,
    this.successMessage,
  });

  const ProductDetailState.initial()
    : isLoading = true,
      product = null,
      isSubmitting = false,
      errorMessage = null,
      successMessage = null;

  ProductDetailState copyWith({
    bool? isLoading,
    ProductEntity? product,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProductDetailState(
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    product,
    isSubmitting,
    errorMessage,
    successMessage,
  ];
}
