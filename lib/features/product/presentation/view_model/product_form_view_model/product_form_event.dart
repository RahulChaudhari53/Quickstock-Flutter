import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductForm extends ProductFormEvent {
  final ProductEntity? product;

  const LoadProductForm({this.product});

  @override
  List<Object?> get props => [product];
}

/// event is triggered when the user submits the form.
class SubmitProductForm extends ProductFormEvent {
  final String? productId; // null in create mode
  final String name;
  final String sku;
  final String categoryId;
  final String supplierId;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final int minStockLevel;
  final String? description;
  final int initialStock;

  const SubmitProductForm({
    this.productId,
    required this.name,
    required this.sku,
    required this.categoryId,
    required this.supplierId,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.minStockLevel,
    this.description,
    required this.initialStock,
  });

  @override
  List<Object?> get props => [
    productId,
    name,
    sku,
    categoryId,
    supplierId,
    unit,
    purchasePrice,
    sellingPrice,
    minStockLevel,
    description,
    initialStock,
  ];
}
