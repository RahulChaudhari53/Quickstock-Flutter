import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/product/domain/entity/product_pagination_entity.dart';

part 'product_pagination_api_model.g.dart';

@JsonSerializable()
class ProductPaginationApiModel {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  ProductPaginationApiModel({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory ProductPaginationApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPaginationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPaginationApiModelToJson(this);

  ProductPaginationEntity toEntity() {
    return ProductPaginationEntity(
      currentPage: currentPage,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
    );
  }
}
