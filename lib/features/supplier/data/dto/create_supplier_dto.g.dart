// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_supplier_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSupplierDto _$CreateSupplierDtoFromJson(Map<String, dynamic> json) =>
    CreateSupplierDto(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreateSupplierDtoToJson(CreateSupplierDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'notes': instance.notes,
    };
