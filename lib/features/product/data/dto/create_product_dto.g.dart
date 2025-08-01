// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProductDto _$CreateProductDtoFromJson(Map<String, dynamic> json) =>
    CreateProductDto(
      name: json['name'] as String,
      sku: json['sku'] as String,
      categoryId: json['category'] as String,
      supplierId: json['supplier'] as String,
      unit: json['unit'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      minStockLevel: (json['minStockLevel'] as num).toInt(),
      description: json['description'] as String?,
      initialStock: (json['initialStock'] as num).toInt(),
    );

Map<String, dynamic> _$CreateProductDtoToJson(CreateProductDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sku': instance.sku,
      'category': instance.categoryId,
      'supplier': instance.supplierId,
      'unit': instance.unit,
      'purchasePrice': instance.purchasePrice,
      'sellingPrice': instance.sellingPrice,
      'minStockLevel': instance.minStockLevel,
      'description': instance.description,
      'initialStock': instance.initialStock,
    };
