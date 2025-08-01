import 'package:equatable/equatable.dart';

class PurchaseItemProductEntity extends Equatable {
  final String id;
  final String name;
  final String sku;
  final String unit;

  const PurchaseItemProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.unit,
  });

  @override
  List<Object?> get props => [id, name, sku, unit];
}
