// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItemProductApiModel _$PurchaseItemProductApiModelFromJson(
        Map<String, dynamic> json) =>
    PurchaseItemProductApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$PurchaseItemProductApiModelToJson(
        PurchaseItemProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'unit': instance.unit,
    };

PurchaseItemApiModel _$PurchaseItemApiModelFromJson(
        Map<String, dynamic> json) =>
    PurchaseItemApiModel(
      id: json['_id'] as String,
      product: PurchaseItemProductApiModel.fromJson(
          json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      unitCost: (json['unitCost'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
    );

Map<String, dynamic> _$PurchaseItemApiModelToJson(
        PurchaseItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product': instance.product,
      'quantity': instance.quantity,
      'unitCost': instance.unitCost,
      'totalCost': instance.totalCost,
    };

PurchaseSupplierApiModel _$PurchaseSupplierApiModelFromJson(
        Map<String, dynamic> json) =>
    PurchaseSupplierApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$PurchaseSupplierApiModelToJson(
        PurchaseSupplierApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
    };

PurchaseApiModel _$PurchaseApiModelFromJson(Map<String, dynamic> json) =>
    PurchaseApiModel(
      id: json['_id'] as String,
      purchaseNumber: json['purchaseNumber'] as String,
      supplier: PurchaseSupplierApiModel.fromJson(
          json['supplier'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => PurchaseItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      purchaseStatus: json['purchaseStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PurchaseApiModelToJson(PurchaseApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'purchaseNumber': instance.purchaseNumber,
      'supplier': instance.supplier,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'purchaseStatus': instance.purchaseStatus,
      'paymentMethod': instance.paymentMethod,
      'orderDate': instance.orderDate.toIso8601String(),
      'notes': instance.notes,
    };

PurchasePaginationApiModel _$PurchasePaginationApiModelFromJson(
        Map<String, dynamic> json) =>
    PurchasePaginationApiModel(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );

Map<String, dynamic> _$PurchasePaginationApiModelToJson(
        PurchasePaginationApiModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };

PurchasesListViewApiModel _$PurchasesListViewApiModelFromJson(
        Map<String, dynamic> json) =>
    PurchasesListViewApiModel(
      purchases: (json['items'] as List<dynamic>)
          .map((e) => PurchaseApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PurchasePaginationApiModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchasesListViewApiModelToJson(
        PurchasesListViewApiModel instance) =>
    <String, dynamic>{
      'items': instance.purchases,
      'pagination': instance.pagination,
    };
