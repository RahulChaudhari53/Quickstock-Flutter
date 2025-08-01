import 'package:equatable/equatable.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_item_product_entity.dart';

class PurchaseItemEntity extends Equatable {
  final String id;
  final PurchaseItemProductEntity product;
  final int quantity;
  final double unitCost;
  final double totalCost;

  const PurchaseItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
  });

  @override
  List<Object?> get props => [id, product, quantity, unitCost, totalCost];
}
