import 'package:json_annotation/json_annotation.dart';

part 'update_product_dto.g.dart';

@JsonSerializable()
class UpdateProductDto {
  final String name;
  @JsonKey(name: 'category')
  final String categoryId;
  @JsonKey(name: 'supplier')
  final String supplierId;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final int minStockLevel;
  final String? description;

  UpdateProductDto({
    required this.name,
    required this.categoryId,
    required this.supplierId,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.minStockLevel,
    this.description,
  });

  factory UpdateProductDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProductDtoToJson(this);
}
