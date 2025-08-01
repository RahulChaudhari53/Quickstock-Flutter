// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleItemProductApiModel _$SaleItemProductApiModelFromJson(
        Map<String, dynamic> json) =>
    SaleItemProductApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$SaleItemProductApiModelToJson(
        SaleItemProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'unit': instance.unit,
    };

SaleItemApiModel _$SaleItemApiModelFromJson(Map<String, dynamic> json) =>
    SaleItemApiModel(
      id: json['_id'] as String,
      product: SaleItemProductApiModel.fromJson(
          json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$SaleItemApiModelToJson(SaleItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product': instance.product,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
    };

SaleApiModel _$SaleApiModelFromJson(Map<String, dynamic> json) => SaleApiModel(
      id: json['_id'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      saleDate: DateTime.parse(json['saleDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SaleApiModelToJson(SaleApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'paymentMethod': instance.paymentMethod,
      'saleDate': instance.saleDate.toIso8601String(),
      'notes': instance.notes,
    };

SalePaginationApiModel _$SalePaginationApiModelFromJson(
        Map<String, dynamic> json) =>
    SalePaginationApiModel(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );

Map<String, dynamic> _$SalePaginationApiModelToJson(
        SalePaginationApiModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };

SalesListViewApiModel _$SalesListViewApiModelFromJson(
        Map<String, dynamic> json) =>
    SalesListViewApiModel(
      sales: (json['items'] as List<dynamic>)
          .map((e) => SaleApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: SalePaginationApiModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SalesListViewApiModelToJson(
        SalesListViewApiModel instance) =>
    <String, dynamic>{
      'items': instance.sales,
      'pagination': instance.pagination,
    };
