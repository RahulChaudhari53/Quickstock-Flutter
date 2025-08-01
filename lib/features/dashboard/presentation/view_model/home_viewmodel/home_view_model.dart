import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/dashboard/domain/usecase/get_dashboard_overview_usecase.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_viewmodel/home_event.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_viewmodel/home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final GetDashboardOverviewUsecase _getDashboardOverviewUsecase;

  HomeViewModel({
    required GetDashboardOverviewUsecase getDashboardOverviewUsecase,
  }) : _getDashboardOverviewUsecase = getDashboardOverviewUsecase,
       super(const HomeState.initial()) {
    on<FetchHomeEvent>(_onFetchDashboardData);
  }

  Future<void> _onFetchDashboardData(
    FetchHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _getDashboardOverviewUsecase(
      GetDashboardOverviewParams(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (overview) => emit(state.copyWith(isLoading: false, overview: overview)),
    );
  }
}
