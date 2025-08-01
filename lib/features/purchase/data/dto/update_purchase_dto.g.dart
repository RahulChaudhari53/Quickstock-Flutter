// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePurchaseDto _$UpdatePurchaseDtoFromJson(Map<String, dynamic> json) =>
    UpdatePurchaseDto(
      supplier: json['supplier'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
              (e) => CreatePurchaseItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      purchaseNumber: json['purchaseNumber'] as String?,
      orderDate: json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
    );

Map<String, dynamic> _$UpdatePurchaseDtoToJson(UpdatePurchaseDto instance) =>
    <String, dynamic>{
      if (instance.supplier case final value?) 'supplier': value,
      if (instance.paymentMethod case final value?) 'paymentMethod': value,
      if (instance.items case final value?) 'items': value,
      if (instance.notes case final value?) 'notes': value,
      if (instance.purchaseNumber case final value?) 'purchaseNumber': value,
      if (instance.orderDate?.toIso8601String() case final value?)
        'orderDate': value,
    };
