// lib/features/categories/presentation/view
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/presentation/view_model/category_event.dart';
import 'package:quickstock/features/categories/presentation/view_model/category_state.dart';
import 'package:quickstock/features/categories/presentation/view_model/category_view_model.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';

class CategoriesView extends PageContent {
  const CategoriesView({super.key});

  @override
  String get title => "Manage Categories";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryViewModel>(
      create: (context) => serviceLocator<CategoryViewModel>(),
      child: const _CategoriesViewBody(),
    );
  }
}

class _CategoriesViewBody extends StatefulWidget {
  const _CategoriesViewBody();

  @override
  State<_CategoriesViewBody> createState() => _CategoriesViewBodyState();
}

class _CategoriesViewBodyState extends State<_CategoriesViewBody> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _sortBy = "desc";
  bool? _isActive;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  // listener for the scroll controller to implement infinite scrolling.
  void _onScroll() {
    if (_isBottom) {
      context.read<CategoryViewModel>().add(FetchNextPageEvent());
    }
  }

  // check if user has scrolled to bottom of list..
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _applyFilters() {
    context.read<CategoryViewModel>().add(
      ApplyFilterEvent(
        searchTerm: _searchController.text.trim(),
        sortBy: _sortBy,
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryViewModel, CategoryState>(
      listener: (context, state) {
        if (state.actionError != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.actionError!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null && state.categories.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryViewModel>().add(
                        FetchCategoryEvent(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // main content - loaded state
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              // allow to pull to refresh
              context.read<CategoryViewModel>().add(FetchCategoryEvent());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: _FilterBar(
                    searchController: _searchController,
                    sortByValue: _sortBy,
                    isActiveValue: _isActive,
                    onSortByChanged:
                        (value) => setState(() => _sortBy = value!),
                    onIsActiveChanged:
                        (value) => setState(() => _isActive = value),
                    onApply: _applyFilters,
                  ),
                ),

                if (state.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: LinearProgressIndicator()),
                    ),
                  ),

                if (!state.isLoading && state.categories.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No categories found. Use the + button to add one!',
                      ),
                    ),
                  ),

                //  Category List
                SliverList.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return _CategoryCard(
                      category: category,
                      isProcessing: state.processingCategoryIds.contains(
                        category.id,
                      ),
                    );
                  },
                ),

                // Pagination Loading Indicator
                if (state.isPaginating)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _showCreateCategoryDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Category'),
          ),
        );
      },
    );
  }

  void _showCreateCategoryDialog(BuildContext parentContext) {
    // we pass the parentContext which contains the CategoryViewModel provider.
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) {
        return BlocProvider.value(
          value: parentContext.read<CategoryViewModel>(),
          child: const _CreateCategoryDialog(),
        );
      },
    );
  }
}

class _FilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String sortByValue;
  final bool? isActiveValue;
  final ValueChanged<String?> onSortByChanged;
  final ValueChanged<bool?> onIsActiveChanged;
  final VoidCallback onApply;

  const _FilterBar({
    required this.searchController,
    required this.sortByValue,
    required this.isActiveValue,
    required this.onSortByChanged,
    required this.onIsActiveChanged,
    required this.onApply,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by category name...',
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
              ),
              filled: true,
              fillColor: colorScheme.surfaceVariant.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 16.0,
              ),
            ),
            style: TextStyle(color: colorScheme.onSurface),
            onSubmitted: (_) => onApply(),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: sortByValue,
                  onChanged: onSortByChanged,
                  decoration: InputDecoration(
                    labelText: 'Sort by',
                    labelStyle: TextStyle(color: colorScheme.onSurface),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
                  ),
                  dropdownColor: colorScheme.surface,
                  items: [
                    DropdownMenuItem(
                      value: 'desc',
                      child: Text(
                        'Newest First',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'asc',
                      child: Text(
                        'Oldest First',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                  ],
                  iconEnabledColor: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onApply,
                icon: Icon(Icons.check, color: colorScheme.onPrimary),
                label: Text(
                  'Apply',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 15,
                  ),
                  textStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: isActiveValue == null,
                onSelected: (_) => onIsActiveChanged(null),
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  color:
                      isActiveValue == null
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                ),
                side:
                    isActiveValue == null
                        ? BorderSide.none
                        : BorderSide(color: colorScheme.outlineVariant),
                showCheckmark: true,
                checkmarkColor: colorScheme.onPrimary,
              ),
              // active Chip
              ChoiceChip(
                label: const Text('Active'),
                selected: isActiveValue == true,
                onSelected: (_) => onIsActiveChanged(true),
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  color:
                      isActiveValue == true
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                ),
                side:
                    isActiveValue == true
                        ? BorderSide.none
                        : BorderSide(color: colorScheme.outlineVariant),
                showCheckmark: true,
                checkmarkColor: colorScheme.onPrimary,
              ),
              // inactive Chip
              ChoiceChip(
                label: const Text('Inactive'),
                selected: isActiveValue == false,
                onSelected: (_) => onIsActiveChanged(false),
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  color:
                      isActiveValue == false
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                ),
                side:
                    isActiveValue == false
                        ? BorderSide.none
                        : BorderSide(color: colorScheme.outlineVariant),
                showCheckmark: true,
                checkmarkColor: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final bool isProcessing;

  const _CategoryCard({required this.category, this.isProcessing = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // status badge
                Chip(
                  label: Text(category.isActive ? 'Active' : 'Inactive'),
                  backgroundColor:
                      category.isActive
                          ? colorScheme.primaryContainer
                          : colorScheme.errorContainer,
                  labelStyle: textTheme.labelSmall?.copyWith(
                    color:
                        category.isActive
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(category.description, style: textTheme.bodyMedium),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isProcessing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                else
                  TextButton.icon(
                    onPressed: () {
                      final event =
                          category.isActive
                              ? DeactivateCategoryEvent(category.id)
                              : ActivateCategoryEvent(category.id);
                      context.read<CategoryViewModel>().add(event);
                    },
                    icon: Icon(
                      category.isActive
                          ? Icons.toggle_off_outlined
                          : Icons.toggle_on,
                      color:
                          category.isActive
                              ? colorScheme.error
                              : colorScheme.primary,
                    ),
                    label: Text(
                      category.isActive ? 'Deactivate' : 'Activate',
                      style: textTheme.labelLarge?.copyWith(
                        color:
                            category.isActive
                                ? colorScheme.error
                                : colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateCategoryDialog extends StatefulWidget {
  const _CreateCategoryDialog();

  @override
  State<_CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<_CreateCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CategoryViewModel>().add(
        CreateCategoryEvent(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryViewModel, CategoryState>(
      listenWhen:
          (previous, current) => previous.isCreating && !current.isCreating,
      listener: (context, state) {
        if (state.actionError == null) {
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: const Text('Create New Category'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'e.g., Electronics',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Category name is required.';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'A short description of the category',
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<CategoryViewModel, CategoryState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.isCreating ? null : _submitForm,
                child:
                    state.isCreating
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Create'),
              );
            },
          ),
        ],
      ),
    );
  }
}
