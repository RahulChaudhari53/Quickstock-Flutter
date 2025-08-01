import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/categories/domain/use_case/activate_category_usecase.dart';
import 'package:quickstock/features/categories/domain/use_case/create_category_usecase.dart';
import 'package:quickstock/features/categories/domain/use_case/deactivate_category_usecase.dart';
import 'package:quickstock/features/categories/domain/use_case/get_all_categories_usecase.dart';
import 'package:quickstock/features/categories/presentation/view_model/category_event.dart';
import 'package:quickstock/features/categories/presentation/view_model/category_state.dart';

class CategoryViewModel extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  final CreateCategoryUsecase _createCategoryUsecase;
  final DeactivateCategoryUsecase _deactivateCategoryUsecase;
  final ActivateCategoryUsecase _activateCategoryUsecase;

  CategoryViewModel({
    required GetAllCategoriesUsecase getAllCategoriesUsecase,
    required CreateCategoryUsecase createCategoryUsecase,
    required DeactivateCategoryUsecase deactivateCategoryUsecase,
    required ActivateCategoryUsecase activateCategoryUsecase,
  }) : _getAllCategoriesUsecase = getAllCategoriesUsecase,
       _createCategoryUsecase = createCategoryUsecase,
       _deactivateCategoryUsecase = deactivateCategoryUsecase,
       _activateCategoryUsecase = activateCategoryUsecase,
       super(const CategoryState.initial()) {
    on<FetchCategoryEvent>(_onFetchCategories);
    on<FetchNextPageEvent>(_onFetchNextPage);
    on<ApplyFilterEvent>(_onApplyFilters);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<DeactivateCategoryEvent>(_onDeactivateCategory);
    on<ActivateCategoryEvent>(_onActivateCategory);

    add(FetchCategoryEvent());
  }

  Future<void> _onApplyFilters(
    ApplyFilterEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        searchTerm: event.searchTerm,
        sortBy: event.sortBy,
        isActive: event.isActive,
        clearIsActiveFilter: event.isActive == null,
      ),
    );

    add(FetchCategoryEvent());
  }

  Future<void> _onFetchCategories(
    FetchCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, categories: [], paginationInfo: null));

    final result = await _getAllCategoriesUsecase(
      GetAllCategoriesParams(
        page: 1,
        limit: 15,
        searchTerm: state.searchTerm,
        sortBy: state.sortBy,
        isActive: state.isActive,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (paginatedData) => emit(
        state.copyWith(
          isLoading: false,
          categories: paginatedData.categories,
          paginationInfo: paginatedData.paginationInfo,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onFetchNextPage(
    FetchNextPageEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.isPaginating || !(state.paginationInfo?.hasNextPage ?? false)) {
      return;
    }

    emit(state.copyWith(isPaginating: true));
    final nextPage = (state.paginationInfo!.currentPage) + 1;
    final result = await _getAllCategoriesUsecase(
      GetAllCategoriesParams(
        page: nextPage,
        limit: 15,
        searchTerm: state.searchTerm,
        sortBy: state.sortBy,
        isActive: state.isActive,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isPaginating: false, actionError: failure.message),
      ),
      (paginatedData) => emit(
        state.copyWith(
          isPaginating: false,
          categories: List.of(state.categories)
            ..addAll(paginatedData.categories),
          paginationInfo: paginatedData.paginationInfo,
        ),
      ),
    );
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isCreating: true, clearActionError: true));

    final result = await _createCategoryUsecase(
      CreateCategoryParams(name: event.name, description: event.description),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isCreating: false, actionError: failure.message)),
      (_) {
        emit(state.copyWith(isCreating: false));
        add(FetchCategoryEvent());
      },
    );
  }

  Future<void> _onDeactivateCategory(
    DeactivateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        processingCategoryIds: {
          ...state.processingCategoryIds,
          event.categoryId,
        },
      ),
    );

    try {
      final result = await _deactivateCategoryUsecase(
        DeactivateCategoryParams(event.categoryId),
      );

      result.fold(
        (failure) => emit(state.copyWith(actionError: failure.message)),
        (_) => add(FetchCategoryEvent()),
      );
    } finally {
      emit(
        state.copyWith(
          processingCategoryIds: {...state.processingCategoryIds}
            ..remove(event.categoryId),
        ),
      );
    }
  }

  Future<void> _onActivateCategory(
    ActivateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        processingCategoryIds: {
          ...state.processingCategoryIds,
          event.categoryId,
        },
      ),
    );

    try {
      final result = await _activateCategoryUsecase(
        ActivateCategoryParams(event.categoryId),
      );

      result.fold(
        (failure) => emit(state.copyWith(actionError: failure.message)),
        (_) => add(FetchCategoryEvent()),
      );
    } finally {
      emit(
        state.copyWith(
          processingCategoryIds: {...state.processingCategoryIds}
            ..remove(event.categoryId),
        ),
      );
    }
  }
}
