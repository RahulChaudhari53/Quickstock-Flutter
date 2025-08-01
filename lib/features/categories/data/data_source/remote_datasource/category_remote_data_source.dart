import 'package:dio/dio.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/features/categories/data/data_source/category_data_source.dart';
import 'package:quickstock/features/categories/data/dto/create_category_dto.dart';
import 'package:quickstock/features/categories/data/dto/get_all_categories_dto.dart';
import 'package:quickstock/features/categories/data/model/category_api_model.dart';

class CategoryRemoteDataSource implements ICategoryDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<CategoryApiModel> createCategory(CreateCategoryDto dto) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.createCategory,
        data: dto.toJson(),
      );

      return CategoryApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed  to create category.",
      );
    }
  }

  @override
  Future<void> deactivateCategory(String categoryId) async {
    try {
      await _apiService.dio.delete(ApiEndpoints.deactivateCategory(categoryId));
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to deactivate category",
      );
    }
  }

  @override
  Future<CategoryApiModel> activateCategory(String categoryId) async {
    try {
      final response = await _apiService.dio.patch(
        ApiEndpoints.activateCategory(categoryId),
      );

      return CategoryApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to activate category",
      );
    }
  }

  @override
  Future<GetAllCategoriesDto> getAllCategories({
    required int page,
    int? limit,
    String? searchTerm,
    String? sortBy,
    bool? isActive,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        if (limit != null) 'limit': limit,
        if (searchTerm != null && searchTerm.isNotEmpty) 'search': searchTerm,
        'sortBy': 'createdAt',
        if (sortBy != null) 'sortOrder': sortBy,
        if (isActive != null) 'isActive': isActive,
      };

      final response = await _apiService.dio.get(
        ApiEndpoints.getAllCategories,
        queryParameters: queryParameters,
      );

      final responseData = response.data['data'] as Map<String, dynamic>;

      return GetAllCategoriesDto.fromJson(responseData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load categories',
      );
    }
  }

  @override
  Future<void> cacheCategories(GetAllCategoriesDto dto) {
    throw UnimplementedError(
      'Caching is not supported by the remote data source.',
    );
  }
}
