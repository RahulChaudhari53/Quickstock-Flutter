import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_category_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_supplier_entity.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String sku;
  final String? description;
  final ProductCategoryEntity category;
  final ProductSupplierEntity supplier;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final List<String> images;
  final int minStockLevel;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int currentStock;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    this.description,
    required this.category,
    required this.supplier,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.images,
    required this.minStockLevel,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.currentStock,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    sku,
    description,
    category,
    supplier,
    unit,
    purchasePrice,
    sellingPrice,
    images,
    minStockLevel,
    isActive,
    createdAt,
    updatedAt,
    currentStock,
  ];
}
