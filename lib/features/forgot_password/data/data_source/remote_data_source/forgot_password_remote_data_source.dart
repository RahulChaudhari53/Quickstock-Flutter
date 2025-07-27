import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/forgot_password/data/data_source/forgot_password_data_source.dart';

class ForgotPasswordRemoteDataSource implements IForgotPasswordDataSource {
  final ApiService _apiService;

  ForgotPasswordRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> sendOtp(String email) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.sendOtp,
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        return response.data['data']['temp_opt_token'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send OTP');
      }
    } catch (err) {
      throw Exception('Failed to send OTP: $err');
    }
  }

  @override
  Future<String> verifyOtp(String otp, String tempToken) async {
    try {
      // manually managing the token
      // so we can tell AuthInterceptor to sit this one out
      final response = await _apiService.dio.post(
        ApiEndpoints.verifyOtp,
        data: {'otp': otp},
        options: Options(
          headers: {'Authorization': 'Bearer $tempToken'},
          extra: {
            'skipAuthInterceptor': true,
          }, // added this line, do same in below api
          // after made changes in auth interceptor
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data']['reset_token'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to verify OTP');
      }
    } on DioException catch (e) {
      throw Exception('Failed to verify OTP: ${e.message}');
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  @override
  Future<void> resetPassword(String newPassword, String resetToken) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.resetPassword,
        data: {'newPassword': newPassword},
        options: Options(
          headers: {'Authorization': 'Bearer $resetToken'},
          extra: {'skipAuthInterceptor': true},
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      throw Exception('Failed to reset password: ${e.message}');
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}
