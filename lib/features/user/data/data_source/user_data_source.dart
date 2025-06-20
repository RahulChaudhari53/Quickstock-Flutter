import 'dart:core';
import 'package:quickstock/features/user/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity user);
  Future<String> loginUser(String phoneNumber, String password);
}
