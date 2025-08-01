import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/purchase/data/data_source/purchase_data_source.dart';
import 'package:quickstock/features/purchase/data/dto/create_purchase_dto.dart';
import 'package:quickstock/features/purchase/data/dto/update_purchase_dto.dart';
import 'package:quickstock/features/purchase/data/model/purchase_api_model.dart';

class PurchaseRemoteDataSource implements IPurchaseDataSource {
  final ApiService _apiService;

  PurchaseRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<PurchasesListViewApiModel> getAllPurchases({
    required int page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? supplierId,
    String? purchaseStatus,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      if (limit != null) 'limit': limit,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (supplierId != null) 'supplier': supplierId,
      if (purchaseStatus != null) 'purchaseStatus': purchaseStatus,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.purchases,
        queryParameters: queryParameters,
      );
      return PurchasesListViewApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load purchases.',
      );
    }
  }

  @override
  Future<PurchaseApiModel> getPurchaseById({required String purchaseId}) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.purchaseById(purchaseId),
      );
      return PurchaseApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load purchase details.',
      );
    }
  }

  @override
  Future<PurchaseApiModel> createPurchase({
    required CreatePurchaseDto createPurchaseDto,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.createPurchase,
        data: createPurchaseDto.toJson(),
      );
      return PurchaseApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create purchase.',
      );
    }
  }

  @override
  Future<PurchaseApiModel> updatePurchase({
    required String purchaseId,
    required UpdatePurchaseDto updatePurchaseDto,
  }) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.updatePurchase(purchaseId),
        data: updatePurchaseDto.toJson(),
      );
      return PurchaseApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update purchase.',
      );
    }
  }

  @override
  Future<void> cancelPurchase({required String purchaseId}) async {
    try {
      await _apiService.dio.patch(ApiEndpoints.cancelPurchase(purchaseId));
      return; // Success returns void
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to cancel purchase.',
      );
    }
  }

  @override
  Future<PurchaseApiModel> receivePurchase({required String purchaseId}) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.receivePurchase(purchaseId),
      );
      return PurchaseApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to receive purchase.',
      );
    }
  }
}
