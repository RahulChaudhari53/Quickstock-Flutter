import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/stock/data/data_source/stock_data_source.dart';
import 'package:quickstock/features/stock/data/model/stock_api_model.dart';
import 'package:quickstock/features/stock/data/model/stock_history_api_model.dart';

class StockRemoteDataSource implements IStockDataSource {
  final ApiService _apiService;

  StockRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<StockListViewApiModel> getAllStock({
    required int page,
    int? limit,
    String? search,
    String? stockStatus,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {'page': page};
      if (limit != null) {
        queryParameters['limit'] = limit;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (stockStatus != null && stockStatus.isNotEmpty) {
        queryParameters['stockStatus'] = stockStatus;
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.getAllStock,
        queryParameters: queryParameters,
      );

      return StockListViewApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load stock data.',
      );
    }
  }

  @override
  Future<StockHistoryViewApiModel> getStockMovementHistory({
    required String productId,
    required int page,
    int? limit,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {'page': page};
      if (limit != null) {
        queryParameters['limit'] = limit;
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.getStockHistory(productId),
        queryParameters: queryParameters,
      );
      return StockHistoryViewApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load stock history.',
      );
    }
  }
}
