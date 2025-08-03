import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, createdBy, isActive];
}
