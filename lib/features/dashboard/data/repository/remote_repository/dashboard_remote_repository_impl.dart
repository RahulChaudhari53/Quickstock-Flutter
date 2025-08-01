import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/dashboard/data/data_source/dashboard_data_source.dart';
import 'package:quickstock/features/dashboard/domain/entity/dashboard_overview_entity.dart';
import 'package:quickstock/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRemoteRepository implements IDashboardRepository {
  final IDashboardDataSource _dataSource;

  DashboardRemoteRepository({required IDashboardDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, DashboardOverviewEntity>> getDashboardOverview({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final dashboardModel = await _dataSource.getDashboardOverview(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(dashboardModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
