import 'package:equatable/equatable.dart';

class SaleItemParam extends Equatable {
  final String productId;
  final int quantity;
  final double unitPrice;

  const SaleItemParam({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [productId, quantity, unitPrice];
}

class CreateSaleParams extends Equatable {
  final String paymentMethod;
  final String? notes;
  final List<SaleItemParam> items;

  const CreateSaleParams({
    required this.paymentMethod,
    this.notes,
    required this.items,
  });

  @override
  List<Object?> get props => [paymentMethod, notes, items];
}
