import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/product/data/model/product_category_api_model.dart';
import 'package:quickstock/features/product/data/model/product_supplier_api_model.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';

part 'product_api_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class ProductApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String sku;
  final String? description;
  final ProductCategoryApiModel category;
  final ProductSupplierApiModel supplier;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final List<String> images;
  final int minStockLevel;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(defaultValue: 0)
  final int currentStock;

  ProductApiModel({
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

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      sku: sku,
      description: description,
      category: category.toEntity(),
      supplier: supplier.toEntity(),
      unit: unit,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      images: images,
      minStockLevel: minStockLevel,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      currentStock: currentStock,
    );
  }
}
