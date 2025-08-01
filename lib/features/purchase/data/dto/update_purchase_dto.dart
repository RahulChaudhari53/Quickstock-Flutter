import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/features/purchase/data/dto/create_purchase_dto.dart';

part 'update_purchase_dto.g.dart';

// reusing the same item dto structure as create dto

@JsonSerializable(
  includeIfNull: false,
) // important tto  prevents sending null fields
class UpdatePurchaseDto extends Equatable {
  final String? supplier;
  final String? paymentMethod;
  final List<CreatePurchaseItemDto>? items;
  final String? notes;
  final String? purchaseNumber;
  final DateTime? orderDate;

  const UpdatePurchaseDto({
    this.supplier,
    this.paymentMethod,
    this.items,
    this.notes,
    this.purchaseNumber,
    this.orderDate,
  });

  factory UpdatePurchaseDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePurchaseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePurchaseDtoToJson(this);

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
