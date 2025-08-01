// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProductDto _$UpdateProductDtoFromJson(Map<String, dynamic> json) =>
    UpdateProductDto(
      name: json['name'] as String,
      categoryId: json['category'] as String,
      supplierId: json['supplier'] as String,
      unit: json['unit'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      minStockLevel: (json['minStockLevel'] as num).toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$UpdateProductDtoToJson(UpdateProductDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.categoryId,
      'supplier': instance.supplierId,
      'unit': instance.unit,
      'purchasePrice': instance.purchasePrice,
      'sellingPrice': instance.sellingPrice,
      'minStockLevel': instance.minStockLevel,
      'description': instance.description,
    };
