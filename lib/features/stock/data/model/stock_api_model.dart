import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/stock/domain/entity/stock_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_list_view_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_pagination_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_product_info_entity.dart';

part 'stock_api_model.g.dart';

// represents the nested category object inside the product
@JsonSerializable()
class StockCategoryInfoApiModel extends Equatable {
  final String name;

  const StockCategoryInfoApiModel({required this.name});

  factory StockCategoryInfoApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockCategoryInfoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockCategoryInfoApiModelToJson(this);

  @override
  List<Object?> get props => [name];
}

// represents the nested product object inside a stock item
@JsonSerializable()
class StockProductInfoApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String sku;
  final int minStockLevel;
  final StockCategoryInfoApiModel? category;

  const StockProductInfoApiModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.minStockLevel,
    this.category,
  });

  factory StockProductInfoApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockProductInfoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockProductInfoApiModelToJson(this);

  StockProductInfoEntity toEntity() {
    return StockProductInfoEntity(
      id: id,
      name: name,
      sku: sku,
      minStockLevel: minStockLevel,
      categoryName: category?.name ?? 'N/A',
    );
  }

  @override
  List<Object?> get props => [id, name, sku, minStockLevel, category];
}

// represents a single stock item in the API response list
@JsonSerializable()
class StockApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final int currentStock;
  final StockProductInfoApiModel product;

  const StockApiModel({
    required this.id,
    required this.currentStock,
    required this.product,
  });

  factory StockApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockApiModelToJson(this);

  StockEntity toEntity() {
    return StockEntity(
      id: id,
      currentStock: currentStock,
      product: product.toEntity(),
    );
  }

  @override
  List<Object?> get props => [id, currentStock, product];
}

// represents the pagination object in the API response
@JsonSerializable()
class StockPaginationApiModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const StockPaginationApiModel({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory StockPaginationApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockPaginationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockPaginationApiModelToJson(this);

  StockPaginationEntity toEntity() {
    return StockPaginationEntity(
      currentPage: currentPage,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPrevPage: hasPrevPage,
    );
  }

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    hasNextPage,
    hasPrevPage,
  ];
}

// represents the entire payload for the getAllStock API response
@JsonSerializable()
class StockListViewApiModel extends Equatable {
  final List<StockApiModel> items;
  final StockPaginationApiModel pagination;

  const StockListViewApiModel({required this.items, required this.pagination});

  factory StockListViewApiModel.fromJson(Map<String, dynamic> json) =>
      _$StockListViewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockListViewApiModelToJson(this);

  StockListViewEntity toEntity() {
    return StockListViewEntity(
      items: items.map((item) => item.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }

  @override
  List<Object?> get props => [items, pagination];
}
