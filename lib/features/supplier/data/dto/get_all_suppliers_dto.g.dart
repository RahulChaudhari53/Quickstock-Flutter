// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_suppliers_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllSuppliersDto _$GetAllSuppliersDtoFromJson(Map<String, dynamic> json) =>
    GetAllSuppliersDto(
      suppliers: (json['data'] as List<dynamic>)
          .map((e) => SupplierApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: SupplierPaginationInfoApiModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetAllSuppliersDtoToJson(GetAllSuppliersDto instance) =>
    <String, dynamic>{
      'data': instance.suppliers,
      'pagination': instance.pagination,
    };
