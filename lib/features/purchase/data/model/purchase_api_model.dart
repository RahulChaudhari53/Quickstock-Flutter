import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_item_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_item_product_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_pagination_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_supplier_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchases_list_view_entity.dart';

part 'purchase_api_model.g.dart';

@JsonSerializable()
class PurchaseItemProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String sku;
  final String unit;

  const PurchaseItemProductApiModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.unit,
  });

  factory PurchaseItemProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemProductApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseItemProductApiModelToJson(this);

  PurchaseItemProductEntity toEntity() =>
      PurchaseItemProductEntity(id: id, name: name, sku: sku, unit: unit);

  @override
  List<Object?> get props => [id, name, sku, unit];
}

@JsonSerializable()
class PurchaseItemApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final PurchaseItemProductApiModel product;
  final int quantity;
  final double unitCost;
  final double totalCost;

  const PurchaseItemApiModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
  });

  factory PurchaseItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseItemApiModelToJson(this);

  PurchaseItemEntity toEntity() => PurchaseItemEntity(
    id: id,
    product: product.toEntity(),
    quantity: quantity,
    unitCost: unitCost,
    totalCost: totalCost,
  );

  @override
  List<Object?> get props => [id, product, quantity, unitCost, totalCost];
}

@JsonSerializable()
class PurchaseSupplierApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String phone;
  final String? email;

  const PurchaseSupplierApiModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });

  factory PurchaseSupplierApiModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSupplierApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseSupplierApiModelToJson(this);

  PurchaseSupplierEntity toEntity() =>
      PurchaseSupplierEntity(id: id, name: name, phone: phone, email: email);

  @override
  List<Object?> get props => [id, name, phone, email];
}

@JsonSerializable()
class PurchaseApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String purchaseNumber;
  final PurchaseSupplierApiModel supplier;
  final List<PurchaseItemApiModel> items;
  final double totalAmount;
  final String purchaseStatus;
  final String paymentMethod;
  final DateTime orderDate;
  final String? notes;

  const PurchaseApiModel({
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

  factory PurchaseApiModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseApiModelToJson(this);

  PurchaseEntity toEntity() => PurchaseEntity(
    id: id,
    purchaseNumber: purchaseNumber,
    supplier: supplier.toEntity(),
    items: items.map((item) => item.toEntity()).toList(),
    totalAmount: totalAmount,
    purchaseStatus: purchaseStatus,
    paymentMethod: paymentMethod,
    orderDate: orderDate,
    notes: notes,
  );

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

@JsonSerializable()
class PurchasePaginationApiModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PurchasePaginationApiModel({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PurchasePaginationApiModel.fromJson(Map<String, dynamic> json) =>
      _$PurchasePaginationApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchasePaginationApiModelToJson(this);

  PurchasePaginationEntity toEntity() => PurchasePaginationEntity(
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
class PurchasesListViewApiModel extends Equatable {
  @JsonKey(name: 'items')
  final List<PurchaseApiModel> purchases;
  final PurchasePaginationApiModel pagination;

  const PurchasesListViewApiModel({
    required this.purchases,
    required this.pagination,
  });

  factory PurchasesListViewApiModel.fromJson(Map<String, dynamic> json) =>
      _$PurchasesListViewApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchasesListViewApiModelToJson(this);

  PurchasesListViewEntity toEntity() => PurchasesListViewEntity(
    purchases: purchases.map((p) => p.toEntity()).toList(),
    pagination: pagination.toEntity(),
  );

  @override
  List<Object?> get props => [purchases, pagination];
}
