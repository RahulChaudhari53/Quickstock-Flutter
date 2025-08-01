import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? description;
  final String createdBy;
  final bool isActive;

  CategoryApiModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    required this.isActive,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    description: description ?? 'No description',
    createdBy: createdBy,
    isActive: isActive,
  );
}
