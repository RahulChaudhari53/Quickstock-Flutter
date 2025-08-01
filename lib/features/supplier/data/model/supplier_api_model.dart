import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';

part 'supplier_api_model.g.dart';

@JsonSerializable()
class SupplierApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupplierApiModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupplierApiModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierApiModelToJson(this);

  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      isActive: isActive,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
