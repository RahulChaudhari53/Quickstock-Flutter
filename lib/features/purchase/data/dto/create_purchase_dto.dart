import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'create_purchase_dto.g.dart';

@JsonSerializable()
class CreatePurchaseItemDto extends Equatable {
  final String product;
  final int quantity;
  final double unitCost;

  const CreatePurchaseItemDto({
    required this.product,
    required this.quantity,
    required this.unitCost,
  });

  factory CreatePurchaseItemDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePurchaseItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePurchaseItemDtoToJson(this);

  @override
  List<Object?> get props => [product, quantity, unitCost];
}

@JsonSerializable()
class CreatePurchaseDto extends Equatable {
  final String supplier;
  final String paymentMethod;
  final List<CreatePurchaseItemDto> items;
  final String? notes;
  final String? purchaseNumber;
  final DateTime? orderDate;

  const CreatePurchaseDto({
    required this.supplier,
    required this.paymentMethod,
    required this.items,
    this.notes,
    this.purchaseNumber,
    this.orderDate,
  });

  factory CreatePurchaseDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePurchaseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePurchaseDtoToJson(this);

  @override
  List<Object?> get props => [
    supplier,
    paymentMethod,
    items,
    notes,
    purchaseNumber,
    orderDate,
  ];
}
