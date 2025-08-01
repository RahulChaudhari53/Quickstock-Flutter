// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_pagination_info_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierPaginationInfoApiModel _$SupplierPaginationInfoApiModelFromJson(
        Map<String, dynamic> json) =>
    SupplierPaginationInfoApiModel(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );

Map<String, dynamic> _$SupplierPaginationInfoApiModelToJson(
        SupplierPaginationInfoApiModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalItems': instance.totalItems,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };
