import 'dart:io';

import 'package:quickstock/features/profile/data/model/profile_api_model.dart';

abstract interface class IProfileDataSource {
  Future<ProfileApiModel> getProfile();

  Future<ProfileApiModel> updateUserInfo({
    required String userId,
    required String firstName,
    required String lastName,
  });

  Future<void> updatePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });

  Future<ProfileApiModel> updateEmail({
    required String userId,
    required String email,
  });

  Future<ProfileApiModel> updateProfileImage({
    required String userId,
    required File image,
  });

  Future<ProfileApiModel> addPhoneNumber({
    required String userId,
    required String phoneNumber,
  });

  Future<ProfileApiModel> deletePhoneNumber({
    required String userId,
    required String phoneNumber,
  });

  Future<void> deactivateAccount({required String userId});
}
