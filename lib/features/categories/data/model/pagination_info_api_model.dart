import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/categories/domain/entity/pagination_info_entity.dart';

part 'pagination_info_api_model.g.dart';

@JsonSerializable()
class PaginationInfoApiModel {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationInfoApiModel({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationInfoApiModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationInfoApiModelToJson(this);

  // Helper method to convert to a Domain Entity
  PaginationInfoEntity toEntity() => PaginationInfoEntity(
    currentPage: currentPage,
    totalPages: totalPages,
    hasNextPage: hasNextPage,
    hasPrevPage: hasPrevPage,
  );
}
