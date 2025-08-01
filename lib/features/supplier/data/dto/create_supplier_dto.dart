import 'package:json_annotation/json_annotation.dart';

part 'create_supplier_dto.g.dart';

@JsonSerializable()
class CreateSupplierDto {
  final String name;
  final String email;
  final String phone;
  final String? notes;

  const CreateSupplierDto({
    required this.name,
    required this.email,
    required this.phone,
    this.notes,
  });

  Map<String, dynamic> toJson() => _$CreateSupplierDtoToJson(this);
}