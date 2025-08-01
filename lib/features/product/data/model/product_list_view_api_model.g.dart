// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_view_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListViewApiModel _$ProductListViewApiModelFromJson(
        Map<String, dynamic> json) =>
    ProductListViewApiModel(
      items: (json['products'] as List<dynamic>)
          .map((e) => ProductApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: ProductPaginationApiModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductListViewApiModelToJson(
        ProductListViewApiModel instance) =>
    <String, dynamic>{
      'products': instance.items.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };
