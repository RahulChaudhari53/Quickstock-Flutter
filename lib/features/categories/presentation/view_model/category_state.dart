import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/entity/pagination_info_entity.dart';

@immutable
class CategoryState extends Equatable {
  final List<CategoryEntity> categories;
  final PaginationInfoEntity? paginationInfo;

  final String? searchTerm;
  final String? sortBy;
  final bool? isActive;

  final bool isLoading;
  final bool isPaginating;
  final Set<String> processingCategoryIds;
  // this is for showing loading state on individual cards
  final bool isCreating;

  final String? errorMessage;
  final String? actionError;

  const CategoryState({
    required this.categories,
    this.paginationInfo,
    this.searchTerm,
    this.sortBy,
    this.isActive,
    this.isLoading = false,
    this.isPaginating = false,
    this.processingCategoryIds = const {},
    this.isCreating = false,
    this.errorMessage,
    this.actionError,
  });

  const CategoryState.initial()
    : categories = const [],
      paginationInfo = null,
      searchTerm = null,
      sortBy = 'desc', // new first
      isActive = null,
      isLoading = true,
      isPaginating = false,
      processingCategoryIds = const {},
      isCreating = false,
      errorMessage = null,
      actionError = null;

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    PaginationInfoEntity? paginationInfo,
    String? searchTerm,
    String? sortBy,
    bool? isActive,
    bool clearIsActiveFilter =
        false, // this is to make sure the isActive state is successfully set to null
    bool? isLoading,
    bool? isPaginating,
    Set<String>? processingCategoryIds,
    bool? isCreating,
    String? errorMessage,
    String? actionError,
    bool clearActionError = false, // utility to easily clear one-time errors
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      paginationInfo: paginationInfo ?? this.paginationInfo,
      searchTerm: searchTerm ?? this.searchTerm,
      sortBy: sortBy ?? this.sortBy,
      // isActive: isActive ?? this.isActive,
      isActive: clearIsActiveFilter ? null : isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      processingCategoryIds:
          processingCategoryIds ?? this.processingCategoryIds,
      isCreating: isCreating ?? this.isCreating,
      errorMessage: errorMessage ?? this.errorMessage,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    paginationInfo,
    searchTerm,
    sortBy,
    isActive,
    isLoading,
    isPaginating,
    processingCategoryIds,
    isCreating,
    errorMessage,
    actionError,
  ];
}
