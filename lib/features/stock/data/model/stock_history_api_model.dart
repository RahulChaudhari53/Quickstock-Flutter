import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/stock/data/model/stock_api_model.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_view_entity.dart';

part 'stock_history_api_model.g.dart';

// represents the nested `movedBy` object in the history item
@JsonSerializable()
class StockHistoryMovedByApiModel extends Equatable {
  final String name;

  const StockHistoryMovedByApiModel({required this.name});

  factory StockHistoryMovedByApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockHistoryMovedByApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockHistoryMovedByApiModelToJson(this);

  @override
  List<Object?> get props => [name];
}

// represents a single item in the `history` array
@JsonSerializable()
class StockHistoryItemApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String movementType;
  final int quantity;
  final DateTime date;
  final String? notes;
  final StockHistoryMovedByApiModel movedBy;

  const StockHistoryItemApiModel({
    required this.id,
    required this.movementType,
    required this.quantity,
    required this.date,
    this.notes,
    required this.movedBy,
  });

  factory StockHistoryItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockHistoryItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockHistoryItemApiModelToJson(this);

  StockHistoryEntity toEntity() {
    return StockHistoryEntity(
      id: id,
      movementType: movementType,
      quantity: quantity,
      date: date,
      notes: notes,
      movedBy: movedBy.name,
    );
  }

  @override
  List<Object?> get props => [id, movementType, quantity, date, notes, movedBy];
}

// represents the entire payload from the getStockMovementHistory endpoint
@JsonSerializable()
class StockHistoryViewApiModel extends Equatable {
  final List<StockHistoryItemApiModel> history;
  final StockPaginationApiModel pagination;

  const StockHistoryViewApiModel({
    required this.history,
    required this.pagination,
  });

  factory StockHistoryViewApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockHistoryViewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockHistoryViewApiModelToJson(this);

  StockHistoryViewEntity toEntity() {
    return StockHistoryViewEntity(
      history: history.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }

  @override
  List<Object?> get props => [history, pagination];
}
