import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/dashboard/domain/entity/dashboard_overview_entity.dart';
import 'package:quickstock/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:quickstock/features/dashboard/domain/usecase/get_dashboard_overview_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late GetDashboardOverviewUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = GetDashboardOverviewUsecase(repository: mockRepository);
  });

  const tDashboardOverview = DashboardOverviewEntity(
    totalStockItems: 5210,
    inventoryPurchaseValue: 150320,
    inventorySellingValue: 325400,
    activeProducts: 430,
    lowStockCount: 45,
    outOfStockCount: 12,
    totalSalesOrders: 89,
    totalRevenue: 95123,
    totalPurchaseOrders: 35,
    totalPurchaseCosts: 75601,
    activeSuppliers: 22,
  );

  final tParams = GetDashboardOverviewParams(
    startDate: DateTime(2025, 7, 1),
    endDate: DateTime(2025, 7, 31),
  );

  group('GetDashboardOverviewUsecase', () {
    test(
      'should get a dashboard overview entity from the repository',
      () async {
        when(
          () => mockRepository.getDashboardOverview(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => const Right(tDashboardOverview));

        final result = await usecase(tParams);

        expect(result, const Right(tDashboardOverview));

        verify(
          () => mockRepository.getDashboardOverview(
            startDate: tParams.startDate,
            endDate: tParams.endDate,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        when(
          () => mockRepository.getDashboardOverview(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            RemoteDatabaseFailure(message: 'Could not connect to the server'),
          ),
        );

        final result = await usecase(tParams);

        expect(
          result,
          const Left(
            RemoteDatabaseFailure(message: 'Could not connect to the server'),
          ),
        );

        verify(
          () => mockRepository.getDashboardOverview(
            startDate: tParams.startDate,
            endDate: tParams.endDate,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
