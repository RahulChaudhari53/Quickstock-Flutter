import 'package:quickstock/features/dashboard/data/model/dashboard_overview_api_model.dart';

abstract interface class IDashboardDataSource {
  Future<DashboardOverviewApiModel> getDashboardOverview({
    DateTime? startDate,
    DateTime? endDate,
  });
}
