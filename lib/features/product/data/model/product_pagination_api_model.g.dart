// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_pagination_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPaginationApiModel _$ProductPaginationApiModelFromJson(
        Map<String, dynamic> json) =>
    ProductPaginationApiModel(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
    );

Map<String, dynamic> _$ProductPaginationApiModelToJson(
        ProductPaginationApiModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
    };
