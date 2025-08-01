import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/dashboard/domain/entity/dashboard_overview_entity.dart';

abstract interface class IDashboardRepository {
  Future<Either<Failure, DashboardOverviewEntity>> getDashboardOverview({
    DateTime? startDate,
    DateTime? endDate,
  });
}
