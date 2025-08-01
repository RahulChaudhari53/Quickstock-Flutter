import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/product/domain/entity/product_supplier_entity.dart';

part 'product_supplier_api_model.g.dart';

@JsonSerializable()
class ProductSupplierApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? phone;
  final String? email;

  ProductSupplierApiModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
  });

  factory ProductSupplierApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSupplierApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSupplierApiModelToJson(this);

  ProductSupplierEntity toEntity() {
    return ProductSupplierEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
    );
  }
}
