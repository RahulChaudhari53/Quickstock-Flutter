import 'package:json_annotation/json_annotation.dart';
import 'package:quickstock/features/dashboard/domain/entity/dashboard_overview_entity.dart';

part 'dashboard_overview_api_model.g.dart';

@JsonSerializable()
class DashboardOverviewApiModel {
  final int totalStockItems;
  final num inventoryPurchaseValue;
  final num inventorySellingValue;
  final int activeProducts;
  final int lowStockCount;
  final int outOfStockCount;
  final int totalSalesOrders;
  final num totalRevenue;
  final int totalPurchaseOrders;
  final num totalPurchaseCosts;
  final int activeSuppliers;

  DashboardOverviewApiModel({
    required this.totalStockItems,
    required this.inventoryPurchaseValue,
    required this.inventorySellingValue,
    required this.activeProducts,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.totalSalesOrders,
    required this.totalRevenue,
    required this.totalPurchaseOrders,
    required this.totalPurchaseCosts,
    required this.activeSuppliers,
  });

  factory DashboardOverviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardOverviewApiModelToJson(this);

  DashboardOverviewEntity toEntity() {
    return DashboardOverviewEntity(
      totalStockItems: totalStockItems,
      inventoryPurchaseValue: inventoryPurchaseValue.toDouble(),
      inventorySellingValue: inventorySellingValue.toDouble(),
      activeProducts: activeProducts,
      lowStockCount: lowStockCount,
      outOfStockCount: outOfStockCount,
      totalSalesOrders: totalSalesOrders,
      totalRevenue: totalRevenue.toDouble(),
      totalPurchaseOrders: totalPurchaseOrders,
      totalPurchaseCosts: totalPurchaseCosts.toDouble(),
      activeSuppliers: activeSuppliers,
    );
  }
}
