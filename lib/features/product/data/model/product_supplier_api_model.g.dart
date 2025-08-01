// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_supplier_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSupplierApiModel _$ProductSupplierApiModelFromJson(
        Map<String, dynamic> json) =>
    ProductSupplierApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ProductSupplierApiModelToJson(
        ProductSupplierApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
    };
