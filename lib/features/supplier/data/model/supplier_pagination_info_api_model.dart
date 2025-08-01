import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_pagination_info_entity.dart';

part 'supplier_pagination_info_api_model.g.dart';

@JsonSerializable()
class SupplierPaginationInfoApiModel {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPrevPage;

  const SupplierPaginationInfoApiModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory SupplierPaginationInfoApiModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierPaginationInfoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierPaginationInfoApiModelToJson(this);

  SupplierPaginationInfoEntity toEntity() {
    return SupplierPaginationInfoEntity(
      currentPage: currentPage,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPrevPage: hasPrevPage,
    );
  }
}
