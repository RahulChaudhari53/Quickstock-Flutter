// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePurchaseItemDto _$CreatePurchaseItemDtoFromJson(
        Map<String, dynamic> json) =>
    CreatePurchaseItemDto(
      product: json['product'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitCost: (json['unitCost'] as num).toDouble(),
    );

Map<String, dynamic> _$CreatePurchaseItemDtoToJson(
        CreatePurchaseItemDto instance) =>
    <String, dynamic>{
      'product': instance.product,
      'quantity': instance.quantity,
      'unitCost': instance.unitCost,
    };

CreatePurchaseDto _$CreatePurchaseDtoFromJson(Map<String, dynamic> json) =>
    CreatePurchaseDto(
      supplier: json['supplier'] as String,
      paymentMethod: json['paymentMethod'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CreatePurchaseItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      purchaseNumber: json['purchaseNumber'] as String?,
      orderDate: json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
    );

Map<String, dynamic> _$CreatePurchaseDtoToJson(CreatePurchaseDto instance) =>
    <String, dynamic>{
      'supplier': instance.supplier,
      'paymentMethod': instance.paymentMethod,
      'items': instance.items,
      'notes': instance.notes,
      'purchaseNumber': instance.purchaseNumber,
      'orderDate': instance.orderDate?.toIso8601String(),
    };
