import 'package:dio/dio.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/user/data/data_source/user_data_source.dart';
import 'package:quickstock/features/user/domain/entity/user_entity.dart';
import 'package:quickstock/features/user/data/model/user_api_model.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> loginUser(String phoneNumber, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'phoneNumber': phoneNumber, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        return token;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception('Failed to login user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }
}
