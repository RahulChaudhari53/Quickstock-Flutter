import 'package:equatable/equatable.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';

enum FormMode { create, edit }

enum FormSubmissionStatus { initial, submitting, success, error }

class ProductFormState extends Equatable {
  final FormMode mode;
  final FormSubmissionStatus status;
  final bool isLoading;
  final ProductEntity? initialProduct;
  final List<CategoryEntity> categories;
  final List<SupplierEntity> suppliers;
  final String? errorMessage;
  final String? successMessage;

  const ProductFormState({
    required this.mode,
    required this.status,
    required this.isLoading,
    this.initialProduct,
    required this.categories,
    required this.suppliers,
    this.errorMessage,
    this.successMessage,
  });

  const ProductFormState.initial()
    : mode = FormMode.create,
      status = FormSubmissionStatus.initial,
      isLoading = true,
      initialProduct = null,
      categories = const [],
      suppliers = const [],
      errorMessage = null,
      successMessage = null;

  ProductFormState copyWith({
    FormMode? mode,
    FormSubmissionStatus? status,
    bool? isLoading,
    ProductEntity? initialProduct,
    List<CategoryEntity>? categories,
    List<SupplierEntity>? suppliers,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProductFormState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      initialProduct: initialProduct ?? this.initialProduct,
      categories: categories ?? this.categories,
      suppliers: suppliers ?? this.suppliers,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    status,
    isLoading,
    initialProduct,
    categories,
    suppliers,
    errorMessage,
    successMessage,
  ];
}
