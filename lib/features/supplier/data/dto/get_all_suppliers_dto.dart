import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/supplier/data/model/supplier_api_model.dart';
import 'package:quickstock/features/supplier/data/model/supplier_pagination_info_api_model.dart';

part 'get_all_suppliers_dto.g.dart';

@JsonSerializable()
class GetAllSuppliersDto {
  @JsonKey(name: 'data')
  final List<SupplierApiModel> suppliers;
  final SupplierPaginationInfoApiModel pagination;

  const GetAllSuppliersDto({required this.suppliers, required this.pagination});

  factory GetAllSuppliersDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllSuppliersDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllSuppliersDtoToJson(this);
}
