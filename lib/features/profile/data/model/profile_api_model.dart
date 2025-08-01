import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';

part 'profile_api_model.g.dart';

@JsonSerializable()
class ProfileApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String primaryPhone;
  final String? secondaryPhone;
  final String? profileImage;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.primaryPhone,
    this.secondaryPhone,
    this.profileImage,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileApiModelToJson(this);

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      primaryPhone: primaryPhone,
      secondaryPhone: secondaryPhone,
      profileImage: profileImage,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
