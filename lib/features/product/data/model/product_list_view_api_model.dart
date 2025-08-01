import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/product/data/model/product_api_model.dart';
import 'package:quickstock/features/product/data/model/product_pagination_api_model.dart';
import 'package:quickstock/features/product/domain/entity/product_list_view_entity.dart';

part 'product_list_view_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductListViewApiModel {
  @JsonKey(name: 'products')
  final List<ProductApiModel> items;
  final ProductPaginationApiModel pagination;

  ProductListViewApiModel({required this.items, required this.pagination});

  factory ProductListViewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListViewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListViewApiModelToJson(this);

  ProductListViewEntity toEntity() {
    return ProductListViewEntity(
      items: items.map((item) => item.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}
