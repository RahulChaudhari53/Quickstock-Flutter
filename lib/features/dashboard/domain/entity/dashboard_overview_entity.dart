import 'package:equatable/equatable.dart';

class DashboardOverviewEntity extends Equatable {
  final int totalStockItems;
  final double inventoryPurchaseValue;
  final double inventorySellingValue;
  final int activeProducts;
  final int lowStockCount;
  final int outOfStockCount;
  final int totalSalesOrders;
  final double totalRevenue;
  final int totalPurchaseOrders;
  final double totalPurchaseCosts;
  final int activeSuppliers;

  const DashboardOverviewEntity({
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

  @override
  List<Object?> get props => [
    totalStockItems,
    inventoryPurchaseValue,
    inventorySellingValue,
    activeProducts,
    lowStockCount,
    outOfStockCount,
    totalSalesOrders,
    totalRevenue,
    totalPurchaseOrders,
    totalPurchaseCosts,
    activeSuppliers,
  ];
}
