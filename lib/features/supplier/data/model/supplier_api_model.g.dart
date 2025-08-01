// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierApiModel _$SupplierApiModelFromJson(Map<String, dynamic> json) =>
    SupplierApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      isActive: json['isActive'] as bool,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SupplierApiModelToJson(SupplierApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'isActive': instance.isActive,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
