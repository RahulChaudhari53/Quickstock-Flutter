import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardLogoutRequested extends DashboardEvent {}
