// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_categories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCategoriesDto _$GetAllCategoriesDtoFromJson(Map<String, dynamic> json) =>
    GetAllCategoriesDto(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfoApiModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetAllCategoriesDtoToJson(
        GetAllCategoriesDto instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'pagination': instance.pagination,
    };
