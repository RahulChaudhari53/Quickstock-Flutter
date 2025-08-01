import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/supplier/data/data_source/supplier_data_source.dart';
import 'package:quickstock/features/supplier/data/dto/create_supplier_dto.dart';
import 'package:quickstock/features/supplier/data/dto/get_all_suppliers_dto.dart';
import 'package:quickstock/features/supplier/data/dto/update_supplier_dto.dart';
import 'package:quickstock/features/supplier/data/model/supplier_api_model.dart';

class SupplierRemoteDataSource implements ISupplierDataSource {
  final ApiService _apiService;

  SupplierRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<SupplierApiModel> createSupplier(
    CreateSupplierDto createSupplierDto,
  ) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.createSupplier,
        data: createSupplierDto.toJson(),
      );
      return SupplierApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to create supplier.",
      );
    }
  }

  @override
  Future<GetAllSuppliersDto> getSuppliers({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
    bool? isActive,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'page': page, 'limit': limit};
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (sortBy != null) queryParameters['sortBy'] = sortBy;
      if (sortOrder != null) queryParameters['sortOrder'] = sortOrder;
      if (isActive != null) queryParameters['isActive'] = isActive;

      final response = await _apiService.dio.get(
        ApiEndpoints.getAllSuppliers,
        queryParameters: queryParameters,
      );

      return GetAllSuppliersDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed  to load suppliers.",
      );
    }
  }

  @override
  Future<SupplierApiModel> getSupplierById(String id) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getSupplierById(id),
      );
      return SupplierApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to load this supplier.",
      );
    }
  }

  @override
  Future<SupplierApiModel> updateSupplier(
    String id,
    UpdateSupplierDto updateSupplierDto,
  ) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.updateSupplier(id),
        data: updateSupplierDto.toJson(),
      );
      return SupplierApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to update supplier.",
      );
    }
  }

  @override
  Future<SupplierApiModel> deactivateSupplier(String id) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.deactivateSupplier(id),
      );
      return SupplierApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to deactivate supplier.",
      );
    }
  }

  @override
  Future<SupplierApiModel> activateSupplier(String id) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.activateSupplier(id),
      );
      return SupplierApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to activate supplier.",
      );
    }
  }
}
