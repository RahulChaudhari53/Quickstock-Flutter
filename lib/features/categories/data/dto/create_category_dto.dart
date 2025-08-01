import 'package:json_annotation/json_annotation.dart';

part 'create_category_dto.g.dart';

@JsonSerializable()
class CreateCategoryDto {
  final String name;
  final String? description;

  CreateCategoryDto({required this.name, this.description});

  Map<String, dynamic> toJson() => _$CreateCategoryDtoToJson(this);
}
