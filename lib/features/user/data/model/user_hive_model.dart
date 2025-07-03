import 'package:hive_flutter/adapters.dart';
import 'package:quickstock/app/constant/hive_table_constant.dart';
import 'package:quickstock/features/user/domain/entity/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String password;

  // @HiveField(5)
  // final List<String> phoneNumbers;

  @HiveField(5)
  final String primaryPhone;

  @HiveField(6)
  final String? secondaryPhone;

  @HiveField(7)
  final String role;

  @HiveField(8)
  final String? profileImage;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  const UserHiveModel({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.primaryPhone,
    this.secondaryPhone,
    this.profileImage,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
  });

  UserHiveModel.initial()
    : userId = '',
      firstName = '',
      lastName = '',
      email = '',
      password = '',
      primaryPhone = "",
      secondaryPhone = "",
      role = '',
      profileImage = '',
      createdAt = DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  factory UserHiveModel.fromEntity(UserEntity user) {
    return UserHiveModel(
      userId: user.userId,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      primaryPhone: user.primaryPhone,
      secondaryPhone: user.secondaryPhone,
      // phoneNumbers: user.phoneNumbers,
      profileImage: user.profileImage,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: '',
      primaryPhone: primaryPhone,
      secondaryPhone: secondaryPhone,
      // phoneNumbers: phoneNumbers,
      profileImage: profileImage,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
