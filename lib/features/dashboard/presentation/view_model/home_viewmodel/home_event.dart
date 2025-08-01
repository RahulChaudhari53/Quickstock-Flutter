import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeEvent extends HomeEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const FetchHomeEvent({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
