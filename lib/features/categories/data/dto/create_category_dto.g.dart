// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryDto _$CreateCategoryDtoFromJson(Map<String, dynamic> json) =>
    CreateCategoryDto(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateCategoryDtoToJson(CreateCategoryDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
