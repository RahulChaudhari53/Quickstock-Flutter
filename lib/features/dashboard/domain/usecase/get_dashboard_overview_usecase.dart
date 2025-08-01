import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/dashboard/domain/entity/dashboard_overview_entity.dart';
import 'package:quickstock/features/dashboard/domain/repository/dashboard_repository.dart';

class GetDashboardOverviewParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetDashboardOverviewParams({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetDashboardOverviewUsecase
    implements
        UsecaseWithParams<DashboardOverviewEntity, GetDashboardOverviewParams> {
  final IDashboardRepository _repository;

  GetDashboardOverviewUsecase({required IDashboardRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, DashboardOverviewEntity>> call(
    GetDashboardOverviewParams params,
  ) async {
    return await _repository.getDashboardOverview(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
