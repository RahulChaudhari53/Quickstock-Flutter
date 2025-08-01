import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/categories/data/model/category_api_model.dart';
import 'package:quickstock/features/categories/data/model/pagination_info_api_model.dart';

part 'get_all_categories_dto.g.dart';

@JsonSerializable()
class GetAllCategoriesDto {
  final List<CategoryApiModel> categories;
  final PaginationInfoApiModel pagination;

  GetAllCategoriesDto({required this.categories, required this.pagination});

  factory GetAllCategoriesDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllCategoriesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCategoriesDtoToJson(this);
}
