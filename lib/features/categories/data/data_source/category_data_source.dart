import 'package:quickstock/features/categories/data/dto/create_category_dto.dart';
import 'package:quickstock/features/categories/data/dto/get_all_categories_dto.dart';
import 'package:quickstock/features/categories/data/model/category_api_model.dart';

abstract interface class ICategoryDataSource {
  Future<GetAllCategoriesDto> getAllCategories({
    required int page,
    int? limit,
    String? searchTerm,
    String? sortBy,
    bool? isActive,
  });

  Future<CategoryApiModel> createCategory(CreateCategoryDto dto);

  Future<void> deactivateCategory(String categoryId);

  Future<CategoryApiModel> activateCategory(String categoryId);

  Future<void> cacheCategories(GetAllCategoriesDto dto);
}
