// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_info_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationInfoApiModel _$PaginationInfoApiModelFromJson(
        Map<String, dynamic> json) =>
    PaginationInfoApiModel(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );

Map<String, dynamic> _$PaginationInfoApiModelToJson(
        PaginationInfoApiModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };
