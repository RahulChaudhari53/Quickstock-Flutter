// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_supplier_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateSupplierDto _$UpdateSupplierDtoFromJson(Map<String, dynamic> json) =>
    UpdateSupplierDto(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$UpdateSupplierDtoToJson(UpdateSupplierDto instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.email case final value?) 'email': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.notes case final value?) 'notes': value,
    };
