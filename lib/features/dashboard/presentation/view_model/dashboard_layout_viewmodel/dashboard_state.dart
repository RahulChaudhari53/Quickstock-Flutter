import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLogoutInProgress extends DashboardState {}

class DashboardLogoutSuccess extends DashboardState {}

class DashboardLogoutFailure extends DashboardState {
  final String message;

  const DashboardLogoutFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
