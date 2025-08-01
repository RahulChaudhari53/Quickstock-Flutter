import 'package:equatable/equatable.dart';
import 'package:quickstock/features/sales/domain/entity/sale_item_product_entity.dart';

// a single item line within a sale record.
class SaleItemEntity extends Equatable {
  final String id;
  final SaleItemProductEntity product;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const SaleItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [id, product, quantity, unitPrice, totalPrice];
}
