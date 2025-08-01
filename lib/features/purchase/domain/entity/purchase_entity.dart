import 'package:equatable/equatable.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_item_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_supplier_entity.dart';

class PurchaseEntity extends Equatable {
  final String id;
  final String purchaseNumber;
  final PurchaseSupplierEntity supplier;
  final List<PurchaseItemEntity> items;
  final double totalAmount;
  final String purchaseStatus;
  final String paymentMethod;
  final DateTime orderDate;
  final String? notes;

  const PurchaseEntity({
    required this.id,
    required this.purchaseNumber,
    required this.supplier,
    required this.items,
    required this.totalAmount,
    required this.purchaseStatus,
    required this.paymentMethod,
    required this.orderDate,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        purchaseNumber,
        supplier,
        items,
        totalAmount,
        purchaseStatus,
        paymentMethod,
        orderDate,
        notes,
      ];
}