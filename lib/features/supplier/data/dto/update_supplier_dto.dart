import 'package:json_annotation/json_annotation.dart';

part 'update_supplier_dto.g.dart';

// includeIfNull, to send only data that we change
@JsonSerializable(includeIfNull: false)
class UpdateSupplierDto {
  final String? name;
  final String? email;
  final String? phone;
  final String? notes;

  const UpdateSupplierDto({this.name, this.email, this.phone, this.notes});

  Map<String, dynamic> toJson() => _$UpdateSupplierDtoToJson(this);
}
