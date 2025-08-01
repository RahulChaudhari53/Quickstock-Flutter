import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/profile/data/data_source/profile_data_source.dart';
import 'package:quickstock/features/profile/data/model/profile_api_model.dart';

class ProfileRemoteDataSource implements IProfileDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<ProfileApiModel> getProfile() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getProfile);
      return ProfileApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to fetch profile.",
      );
    }
  }

  @override
  Future<ProfileApiModel> updateUserInfo({
    required String userId,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.updateUserInfo(userId),
        data: {'firstName': firstName, 'lastName': lastName},
      );
      return ProfileApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to update user info.",
      );
    }
  }

  @override
  Future<void> updatePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.dio.patch(
        ApiEndpoints.updatePassword(userId),
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to update password.",
      );
    }
  }

  @override
  Future<ProfileApiModel> updateEmail({
    required String userId,
    required String email,
  }) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.updateEmail(userId),
        data: {'email': email},
      );
      return ProfileApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to update email.");
    }
  }

  @override
  Future<ProfileApiModel> updateProfileImage({
    required String userId,
    required File image,
  }) async {
    try {
      final fileName = image.path.split('/').last;
      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final response = await _apiService.dio.patch(
        ApiEndpoints.updateProfileImage(userId),
        data: formData,
      );
      return ProfileApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to update profile image.",
      );
    }
  }

  @override
  Future<ProfileApiModel> addPhoneNumber({
    required String userId,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.addPhoneNumber(userId),
        data: {'phoneNumber': phoneNumber},
      );
      return ProfileApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to add phone number.",
      );
    }
  }

  @override
  Future<ProfileApiModel> deletePhoneNumber({
    required String userId,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.deletePhoneNumber(userId),
        data: {'phoneNumber': phoneNumber},
      );
      return ProfileApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to delete phone number.",
      );
    }
  }

  @override
  Future<void> deactivateAccount({required String userId}) async {
    try {
      await _apiService.dio.delete(ApiEndpoints.deactivateAccount(userId));
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to deactivate account.",
      );
    }
  }
}
