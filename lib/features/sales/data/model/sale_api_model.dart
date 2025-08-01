import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sale_item_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sale_item_product_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sale_pagination_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sales_list_view_entity.dart';

part 'sale_api_model.g.dart';

@JsonSerializable()
class SaleItemProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String sku;
  final String unit;

  const SaleItemProductApiModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.unit,
  });

  factory SaleItemProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleItemProductApiModelToJson(this);

  SaleItemProductEntity toEntity() =>
      SaleItemProductEntity(id: id, name: name, sku: sku, unit: unit);

  @override
  List<Object?> get props => [id, name, sku, unit];
}

@JsonSerializable()
class SaleItemApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final SaleItemProductApiModel product;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const SaleItemApiModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory SaleItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleItemApiModelToJson(this);

  SaleItemEntity toEntity() => SaleItemEntity(
    id: id,
    product: product.toEntity(),
    quantity: quantity,
    unitPrice: unitPrice,
    totalPrice: totalPrice,
  );

  @override
  List<Object?> get props => [id, product, quantity, unitPrice, totalPrice];
}

@JsonSerializable()
class SaleApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String invoiceNumber;
  final List<SaleItemApiModel> items;
  final double totalAmount;
  final String paymentMethod;
  final DateTime saleDate;
  final String? notes;

  const SaleApiModel({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.saleDate,
    this.notes,
  });

  factory SaleApiModel.fromJson(Map<String, dynamic> json) =>
      _$SaleApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleApiModelToJson(this);

  SaleEntity toEntity() => SaleEntity(
    id: id,
    invoiceNumber: invoiceNumber,
    items: items.map((item) => item.toEntity()).toList(),
    totalAmount: totalAmount,
    paymentMethod: paymentMethod,
    saleDate: saleDate,
    notes: notes,
  );

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

@JsonSerializable()
class SalePaginationApiModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const SalePaginationApiModel({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory SalePaginationApiModel.fromJson(Map<String, dynamic> json) =>
      _$SalePaginationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalePaginationApiModelToJson(this);

  SalePaginationEntity toEntity() => SalePaginationEntity(
    currentPage: currentPage,
    totalPages: totalPages,
    hasNextPage: hasNextPage,
    hasPrevPage: hasPrevPage,
  );

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    hasNextPage,
    hasPrevPage,
  ];
}

@JsonSerializable()
class SalesListViewApiModel extends Equatable {
  @JsonKey(name: 'items')
  final List<SaleApiModel> sales;
  final SalePaginationApiModel pagination;

  const SalesListViewApiModel({required this.sales, required this.pagination});

  factory SalesListViewApiModel.fromJson(Map<String, dynamic> json) =>
      _$SalesListViewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesListViewApiModelToJson(this);

  SalesListViewEntity toEntity() => SalesListViewEntity(
    sales: sales.map((sale) => sale.toEntity()).toList(),
    pagination: pagination.toEntity(),
  );

  @override
  List<Object?> get props => [sales, pagination];
}
