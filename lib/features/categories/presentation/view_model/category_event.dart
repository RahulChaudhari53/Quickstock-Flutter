import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategoryEvent extends CategoryEvent {}

class FetchNextPageEvent extends CategoryEvent {}

class ApplyFilterEvent extends CategoryEvent {
  final String? searchTerm;
  final String? sortBy;
  final bool? isActive;

  const ApplyFilterEvent({this.searchTerm, this.sortBy, this.isActive});

  @override
  List<Object?> get props => [searchTerm, sortBy, isActive];
}

class CreateCategoryEvent extends CategoryEvent {
  final String name;
  final String? description;

  const CreateCategoryEvent({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class DeactivateCategoryEvent extends CategoryEvent {
  final String categoryId;

  const DeactivateCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class ActivateCategoryEvent extends CategoryEvent {
  final String categoryId;

  const ActivateCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
