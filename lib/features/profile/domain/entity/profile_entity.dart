import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
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

  const ProfileEntity({
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

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    primaryPhone,
    secondaryPhone,
    profileImage,
    role,
    isActive,
    createdAt,
    updatedAt,
  ];
}
