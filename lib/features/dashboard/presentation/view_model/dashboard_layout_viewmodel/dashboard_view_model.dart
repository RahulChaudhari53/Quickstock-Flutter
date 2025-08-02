import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/dashboard/domain/usecase/user_logout_usecase.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_layout_viewmodel/dashboard_event.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_layout_viewmodel/dashboard_state.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final LogoutUseCase _logoutUseCase;

  DashboardViewModel({required LogoutUseCase logoutUseCase})
    : _logoutUseCase = logoutUseCase,
      super(DashboardInitial()) {
    on<DashboardLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    DashboardLogoutRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLogoutInProgress());
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(DashboardLogoutFailure(message: failure.message)),
      (_) => emit(DashboardLogoutSuccess()),
    );
  }
}
