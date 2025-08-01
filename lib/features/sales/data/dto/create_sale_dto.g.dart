// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_sale_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSaleItemDto _$CreateSaleItemDtoFromJson(Map<String, dynamic> json) =>
    CreateSaleItemDto(
      product: json['product'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$CreateSaleItemDtoToJson(CreateSaleItemDto instance) =>
    <String, dynamic>{
      'product': instance.product,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };

CreateSaleDto _$CreateSaleDtoFromJson(Map<String, dynamic> json) =>
    CreateSaleDto(
      paymentMethod: json['paymentMethod'] as String,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => CreateSaleItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateSaleDtoToJson(CreateSaleDto instance) =>
    <String, dynamic>{
      'paymentMethod': instance.paymentMethod,
      'notes': instance.notes,
      'items': instance.items,
    };
