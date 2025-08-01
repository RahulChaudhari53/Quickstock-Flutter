// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      description: json['description'] as String?,
      category: ProductCategoryApiModel.fromJson(
          json['category'] as Map<String, dynamic>),
      supplier: ProductSupplierApiModel.fromJson(
          json['supplier'] as Map<String, dynamic>),
      unit: json['unit'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      minStockLevel: (json['minStockLevel'] as num).toInt(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currentStock: (json['currentStock'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'description': instance.description,
      'category': instance.category.toJson(),
      'supplier': instance.supplier.toJson(),
      'unit': instance.unit,
      'purchasePrice': instance.purchasePrice,
      'sellingPrice': instance.sellingPrice,
      'images': instance.images,
      'minStockLevel': instance.minStockLevel,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'currentStock': instance.currentStock,
    };
