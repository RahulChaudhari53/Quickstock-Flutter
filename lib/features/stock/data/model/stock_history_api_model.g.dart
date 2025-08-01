// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_history_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockHistoryMovedByApiModel _$StockHistoryMovedByApiModelFromJson(
        Map<String, dynamic> json) =>
    StockHistoryMovedByApiModel(
      name: json['name'] as String,
    );

Map<String, dynamic> _$StockHistoryMovedByApiModelToJson(
        StockHistoryMovedByApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

StockHistoryItemApiModel _$StockHistoryItemApiModelFromJson(
        Map<String, dynamic> json) =>
    StockHistoryItemApiModel(
      id: json['_id'] as String,
      movementType: json['movementType'] as String,
      quantity: (json['quantity'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      movedBy: StockHistoryMovedByApiModel.fromJson(
          json['movedBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockHistoryItemApiModelToJson(
        StockHistoryItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'movementType': instance.movementType,
      'quantity': instance.quantity,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
      'movedBy': instance.movedBy,
    };

StockHistoryViewApiModel _$StockHistoryViewApiModelFromJson(
        Map<String, dynamic> json) =>
    StockHistoryViewApiModel(
      history: (json['history'] as List<dynamic>)
          .map((e) =>
              StockHistoryItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: StockPaginationApiModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockHistoryViewApiModelToJson(
        StockHistoryViewApiModel instance) =>
    <String, dynamic>{
      'history': instance.history,
      'pagination': instance.pagination,
    };
