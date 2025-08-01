import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'create_sale_dto.g.dart';

@JsonSerializable()
class CreateSaleItemDto extends Equatable {
  final String product;
  final int quantity;
  final double unitPrice;

  const CreateSaleItemDto({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  factory CreateSaleItemDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSaleItemDtoToJson(this);

  @override
  List<Object?> get props => [product, quantity, unitPrice];
}

@JsonSerializable()
class CreateSaleDto extends Equatable {
  final String paymentMethod;
  final String? notes;
  final List<CreateSaleItemDto> items;

  const CreateSaleDto({
    required this.paymentMethod,
    this.notes,
    required this.items,
  });

  factory CreateSaleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSaleDtoToJson(this);

  @override
  List<Object?> get props => [paymentMethod, notes, items];
}
