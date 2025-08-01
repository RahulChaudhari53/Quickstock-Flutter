import 'package:quickstock/features/stock/data/model/stock_api_model.dart';
import 'package:quickstock/features/stock/data/model/stock_history_api_model.dart';

abstract class IStockDataSource {
  Future<StockListViewApiModel> getAllStock({
    required int page,
    int? limit,
    String? search,
    String? stockStatus,
  });

  Future<StockHistoryViewApiModel> getStockMovementHistory({
    required String productId,
    required int page,
    int? limit,
  });
}
