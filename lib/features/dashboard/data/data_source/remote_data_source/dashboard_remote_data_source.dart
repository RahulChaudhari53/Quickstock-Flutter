import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/dashboard/data/data_source/dashboard_data_source.dart';
import 'package:quickstock/features/dashboard/data/model/dashboard_overview_api_model.dart';

class DashboardRemoteDataSource implements IDashboardDataSource {
  final ApiService _apiService;

  DashboardRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<DashboardOverviewApiModel> getDashboardOverview({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (startDate != null) {
        queryParameters['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.dashboardOverview,
        queryParameters: queryParameters,
      );

      return DashboardOverviewApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to load dashboard data.",
      );
    }
  }
}
