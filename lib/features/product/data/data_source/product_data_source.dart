import 'package:quickstock/features/product/data/dto/create_product_dto.dart';
import 'package:quickstock/features/product/data/dto/update_product_dto.dart';
import 'package:quickstock/features/product/data/model/product_api_model.dart';
import 'package:quickstock/features/product/data/model/product_list_view_api_model.dart';

abstract interface class IProductDataSource {
  Future<ProductListViewApiModel> getAllProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
    String? supplierId,
    String? stockStatus,
    bool? isActive,
  });

  Future<ProductApiModel> getProductById(String productId);

  Future<ProductApiModel> createProduct(CreateProductDto dto);

  Future<ProductApiModel> updateProduct(String productId, UpdateProductDto dto);

  Future<ProductApiModel> deactivateProduct(String productId);

  Future<ProductApiModel> activateProduct(String productId);
}
