// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileApiModel _$ProfileApiModelFromJson(Map<String, dynamic> json) =>
    ProfileApiModel(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      primaryPhone: json['primaryPhone'] as String,
      secondaryPhone: json['secondaryPhone'] as String?,
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProfileApiModelToJson(ProfileApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'primaryPhone': instance.primaryPhone,
      'secondaryPhone': instance.secondaryPhone,
      'profileImage': instance.profileImage,
      'role': instance.role,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
