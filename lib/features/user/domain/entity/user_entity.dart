import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String firstName;
  final String lastName;
  final String email;
  // final List<String> phoneNumbers;
  final String primaryPhone;
  final String? secondaryPhone;
  final String? profileImage;
  final String role;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    // required this.phoneNumbers,
    required this.primaryPhone,
    this.secondaryPhone,
    this.profileImage,
    required this.role,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    email,
    // phoneNumbers,
    primaryPhone,
    secondaryPhone,
    profileImage,
    role,
    password,
    createdAt,
    updatedAt,
  ];
}
