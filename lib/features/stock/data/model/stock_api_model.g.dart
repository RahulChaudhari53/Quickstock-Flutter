// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockCategoryInfoApiModel _$StockCategoryInfoApiModelFromJson(
        Map<String, dynamic> json) =>
    StockCategoryInfoApiModel(
      name: json['name'] as String,
    );

Map<String, dynamic> _$StockCategoryInfoApiModelToJson(
        StockCategoryInfoApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

StockProductInfoApiModel _$StockProductInfoApiModelFromJson(
        Map<String, dynamic> json) =>
    StockProductInfoApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      minStockLevel: (json['minStockLevel'] as num).toInt(),
      category: json['category'] == null
          ? null
          : StockCategoryInfoApiModel.fromJson(
              json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockProductInfoApiModelToJson(
        StockProductInfoApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'minStockLevel': instance.minStockLevel,
      'category': instance.category,
    };

StockApiModel _$StockApiModelFromJson(Map<String, dynamic> json) =>
    StockApiModel(
      id: json['_id'] as String,
      currentStock: (json['currentStock'] as num).toInt(),
      product: StockProductInfoApiModel.fromJson(
          json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockApiModelToJson(StockApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'currentStock': instance.currentStock,
      'product': instance.product,
    };

StockPaginationApiModel _$StockPaginationApiModelFromJson(
        Map<String, dynamic> json) =>
    StockPaginationApiModel(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );

Map<String, dynamic> _$StockPaginationApiModelToJson(
        StockPaginationApiModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };

StockListViewApiModel _$StockListViewApiModelFromJson(
        Map<String, dynamic> json) =>
    StockListViewApiModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => StockApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: StockPaginationApiModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockListViewApiModelToJson(
        StockListViewApiModel instance) =>
    <String, dynamic>{
      'items': instance.items,
      'pagination': instance.pagination,
    };
