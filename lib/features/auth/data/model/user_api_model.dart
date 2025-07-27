import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: "_id")
  final String? userId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String primaryPhone;
  final String? secondaryPhone;
  final String? profileImage;
  final String role;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  const UserApiModel({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.primaryPhone,
    this.secondaryPhone,
    this.profileImage,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization methods
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  // Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      primaryPhone: primaryPhone,
      secondaryPhone: secondaryPhone,
      profileImage: profileImage,
      role: role,
      password: password,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
      primaryPhone: entity.primaryPhone,
      secondaryPhone: entity.secondaryPhone,
      profileImage: entity.profileImage,
      role: entity.role,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    email,
    password,
    primaryPhone,
    secondaryPhone,
    profileImage,
    role,
    createdAt,
    updatedAt,
  ];

  // Helper methods for DateTime conversion
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();
}
