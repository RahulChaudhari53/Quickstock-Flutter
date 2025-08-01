import 'package:equatable/equatable.dart';

// this is a single stock movement like sale, adjustment, customer return
class StockHistoryEntity extends Equatable {
  final String id;
  final String movementType;
  final int quantity;
  final DateTime date;
  final String? notes;
  final String movedBy;

  const StockHistoryEntity({
    required this.id,
    required this.movementType,
    required this.quantity,
    required this.date,
    this.notes,
    required this.movedBy,
  });

  @override
  List<Object?> get props => [id, movementType, quantity, date, notes, movedBy];
}
