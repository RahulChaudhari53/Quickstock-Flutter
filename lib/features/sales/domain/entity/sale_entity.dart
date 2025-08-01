import 'package:equatable/equatable.dart';
import 'package:quickstock/features/sales/domain/entity/sale_item_entity.dart';

// represent a complete sale transaction record.
class SaleEntity extends Equatable {
  final String id;
  final String invoiceNumber;
  final List<SaleItemEntity> items;
  final double totalAmount;
  final String paymentMethod;
  final DateTime saleDate;
  final String? notes;

  const SaleEntity({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.saleDate,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        invoiceNumber,
        items,
        totalAmount,
        paymentMethod,
        saleDate,
        notes,
      ];
}