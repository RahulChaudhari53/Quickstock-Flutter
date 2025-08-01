import 'package:json_annotation/json_annotation.dart';

part 'create_product_dto.g.dart';

@JsonSerializable()
class CreateProductDto {
  final String name;
  final String sku;
  @JsonKey(name: 'category')
  final String categoryId;
  @JsonKey(name: 'supplier')
  final String supplierId;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final int minStockLevel;
  final String? description;
  final int initialStock;

  CreateProductDto({
    required this.name,
    required this.sku,
    required this.categoryId,
    required this.supplierId,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.minStockLevel,
    this.description,
    required this.initialStock,
  });

  factory CreateProductDto.fromJson(Map<String, dynamic> json) =>
      _$CreateProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProductDtoToJson(this);
}
