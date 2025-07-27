// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      primaryPhone: json['primaryPhone'] as String,
      secondaryPhone: json['secondaryPhone'] as String?,
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String,
      createdAt: UserApiModel._dateTimeFromJson(json['createdAt'] as String),
      updatedAt: UserApiModel._dateTimeFromJson(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'primaryPhone': instance.primaryPhone,
      'secondaryPhone': instance.secondaryPhone,
      'profileImage': instance.profileImage,
      'role': instance.role,
      'createdAt': UserApiModel._dateTimeToJson(instance.createdAt),
      'updatedAt': UserApiModel._dateTimeToJson(instance.updatedAt),
    };
