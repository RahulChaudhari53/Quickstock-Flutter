import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/product/domain/entity/product_category_entity.dart';

part 'product_category_api_model.g.dart';

@JsonSerializable()
class ProductCategoryApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;

  ProductCategoryApiModel({
    required this.id,
    required this.name,
  });

  factory ProductCategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryApiModelToJson(this);

  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(
      id: id,
      name: name,
    );
  }
}