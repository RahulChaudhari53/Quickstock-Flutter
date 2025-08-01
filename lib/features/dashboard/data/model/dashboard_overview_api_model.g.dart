// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_overview_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardOverviewApiModel _$DashboardOverviewApiModelFromJson(
        Map<String, dynamic> json) =>
    DashboardOverviewApiModel(
      totalStockItems: (json['totalStockItems'] as num).toInt(),
      inventoryPurchaseValue: json['inventoryPurchaseValue'] as num,
      inventorySellingValue: json['inventorySellingValue'] as num,
      activeProducts: (json['activeProducts'] as num).toInt(),
      lowStockCount: (json['lowStockCount'] as num).toInt(),
      outOfStockCount: (json['outOfStockCount'] as num).toInt(),
      totalSalesOrders: (json['totalSalesOrders'] as num).toInt(),
      totalRevenue: json['totalRevenue'] as num,
      totalPurchaseOrders: (json['totalPurchaseOrders'] as num).toInt(),
      totalPurchaseCosts: json['totalPurchaseCosts'] as num,
      activeSuppliers: (json['activeSuppliers'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardOverviewApiModelToJson(
        DashboardOverviewApiModel instance) =>
    <String, dynamic>{
      'totalStockItems': instance.totalStockItems,
      'inventoryPurchaseValue': instance.inventoryPurchaseValue,
      'inventorySellingValue': instance.inventorySellingValue,
      'activeProducts': instance.activeProducts,
      'lowStockCount': instance.lowStockCount,
      'outOfStockCount': instance.outOfStockCount,
      'totalSalesOrders': instance.totalSalesOrders,
      'totalRevenue': instance.totalRevenue,
      'totalPurchaseOrders': instance.totalPurchaseOrders,
      'totalPurchaseCosts': instance.totalPurchaseCosts,
      'activeSuppliers': instance.activeSuppliers,
    };
