import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/sales/data/data_source/sale_data_source.dart';
import 'package:quickstock/features/sales/data/dto/create_sale_dto.dart';
import 'package:quickstock/features/sales/data/model/sale_api_model.dart';

class SaleRemoteDataSource implements ISaleDataSource {
  final ApiService _apiService;

  SaleRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<SalesListViewApiModel> getAllSales({
    required int page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? paymentMethod,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        if (limit != null) 'limit': limit,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        if (paymentMethod != null && paymentMethod.isNotEmpty)
          'paymentMethod': paymentMethod,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _apiService.dio.get(
        ApiEndpoints.getAllSales,
        queryParameters: queryParameters,
      );

      return SalesListViewApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load sales');
    }
  }

  @override
  Future<SaleApiModel> getSaleById({required String saleId}) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getSaleById(saleId),
      );
      return SaleApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load sale details',
      );
    }
  }

  @override
  Future<SaleApiModel> createSale({
    required CreateSaleDto createSaleDto,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.createSale,
        data: createSaleDto.toJson(),
      );
      return SaleApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create sale');
    }
  }

  @override
  Future<void> cancelSale({required String saleId}) async {
    try {
      await _apiService.dio.delete(ApiEndpoints.cancelSale(saleId));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to cancel sale');
    }
  }
}
