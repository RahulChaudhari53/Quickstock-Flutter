import 'package:equatable/equatable.dart';
import 'package:quickstock/features/dashboard/domain/entity/dashboard_overview_entity.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final DashboardOverviewEntity? overview;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    this.overview,
    this.errorMessage,
  });

  const HomeState.initial()
    : isLoading = false,
      overview = null,
      errorMessage = null;

  HomeState copyWith({
    bool? isLoading,
    DashboardOverviewEntity? overview,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      overview: overview ?? this.overview,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, overview, errorMessage];
}
