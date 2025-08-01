import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/product/data/data_source/product_data_source.dart';
import 'package:quickstock/features/product/data/dto/create_product_dto.dart';
import 'package:quickstock/features/product/data/dto/update_product_dto.dart';
import 'package:quickstock/features/product/data/model/product_api_model.dart';
import 'package:quickstock/features/product/data/model/product_list_view_api_model.dart';

class ProductRemoteDataSource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<ProductListViewApiModel> getAllProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
    String? supplierId,
    String? stockStatus,
    bool? isActive,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'page': page, 'limit': limit};
      if (search != null) queryParameters['search'] = search;
      if (categoryId != null) queryParameters['category'] = categoryId;
      if (supplierId != null) queryParameters['supplier'] = supplierId;
      if (stockStatus != null) queryParameters['stockStatus'] = stockStatus;
      if (isActive != null) queryParameters['isActive'] = isActive;

      final response = await _apiService.dio.get(
        ApiEndpoints.getAllProducts,
        queryParameters: queryParameters,
      );
      return ProductListViewApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load products.',
      );
    }
  }

  @override
  Future<ProductApiModel> getProductById(String productId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getProductById(productId),
      );
      return ProductApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load product details.',
      );
    }
  }

  @override
  Future<ProductApiModel> createProduct(CreateProductDto dto) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.createProduct,
        data: dto.toJson(),
      );
      return ProductApiModel.fromJson(response.data['data']['product']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create product.',
      );
    }
  }

  @override
  Future<ProductApiModel> updateProduct(
    String productId,
    UpdateProductDto dto,
  ) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.updateProduct(productId),
        data: dto.toJson(),
      );
      return ProductApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update product.',
      );
    }
  }

  @override
  Future<ProductApiModel> deactivateProduct(String productId) async {
    try {
      final response = await _apiService.dio.delete(
        ApiEndpoints.deactivateProduct(productId),
      );
      return ProductApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to deactivate product.',
      );
    }
  }

  @override
  Future<ProductApiModel> activateProduct(String productId) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.activateProduct(productId),
      );
      return ProductApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to activate product.',
      );
    }
  }
}
