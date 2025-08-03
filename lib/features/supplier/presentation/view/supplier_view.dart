import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/supplier/presentation/widgets/supplier_card.dart';
import 'package:quickstock/features/supplier/presentation/widgets/supplier_form_dialog.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_event.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_state.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_view_model.dart';

class SuppliersView extends PageContent {
  const SuppliersView({super.key});

  @override
  String get title => 'Manage Suppliers';

  IconData get icon => Icons.people_alt_outlined;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupplierViewModel>(
      create:
          (context) =>
              serviceLocator<SupplierViewModel>()..add(FetchSuppliersEvent()),
      child: const _SuppliersViewBody(),
    );
  }
}

class _SuppliersViewBody extends StatefulWidget {
  const _SuppliersViewBody();

  @override
  State<_SuppliersViewBody> createState() => SuppliersViewBodyState();
}

class SuppliersViewBodyState extends State<_SuppliersViewBody> {
  final scrollController = ScrollController();
  late final TextEditingController searchController;

  String sortByValue = 'createdAt';
  String sortOrderValue = 'desc';
  bool? isActiveValue = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);

    final initialState = context.read<SupplierViewModel>().state;
    searchController = TextEditingController(text: initialState.searchTerm);
    sortByValue = initialState.sortBy;
    sortOrderValue = initialState.sortOrder;
    isActiveValue = initialState.isActive;
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      context.read<SupplierViewModel>().add(FetchNextPageEvent());
    }
  }

  void applyFilters() {
    context.read<SupplierViewModel>().add(
      SupplierFiltersEvent(
        searchTerm: searchController.text.trim(),
        sortBy: sortByValue,
        sortOrder: sortOrderValue,
        isActive: isActiveValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            buildFilterBar(),
            const SizedBox(height: 16),
            Expanded(child: buildListView()),
          ],
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFilterBar() {
    final theme = Theme.of(context);
    final borderColor =
        (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;
    final List<({String label, bool? value})> statusChoices = [
      (label: 'All', value: null),
      (label: 'Active', value: true),
      (label: 'Inactive', value: false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search by name, email, or phone...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (_) => applyFilters(),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: '$sortByValue:$sortOrderValue',
                decoration: const InputDecoration(labelText: 'Sort By'),
                items: const [
                  DropdownMenuItem(
                    value: 'createdAt:desc',
                    child: Text('Newest First'),
                  ),
                  DropdownMenuItem(
                    value: 'createdAt:asc',
                    child: Text('Oldest First'),
                  ),
                  DropdownMenuItem(
                    value: 'name:asc',
                    child: Text('Name (A-Z)'),
                  ),
                  DropdownMenuItem(
                    value: 'name:desc',
                    child: Text('Name (Z-A)'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  final parts = value.split(':');
                  setState(() {
                    sortByValue = parts[0];
                    sortOrderValue = parts[1];
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: applyFilters,
              icon: const Icon(Icons.check),
              label: const Text('Apply'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 8.0,
          children:
              statusChoices.map((choice) {
                final isSelected = isActiveValue == choice.value;
                return ChoiceChip(
                  label: Text(choice.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        isActiveValue = choice.value;
                      });
                    }
                  },
                  showCheckmark: false,
                  selectedColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                  ),
                  side:
                      isSelected
                          ? BorderSide.none
                          : BorderSide(color: borderColor),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget buildListView() {
    return BlocConsumer<SupplierViewModel, SupplierState>(
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
          context.read<SupplierViewModel>().add(SupplierActionErrorHandled());
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.suppliers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null && state.suppliers.isEmpty) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

        if (state.suppliers.isEmpty) {
          return const Center(child: Text('No suppliers found.'));
        }

        return RefreshIndicator(
          onRefresh:
              () async =>
                  context.read<SupplierViewModel>().add(FetchSuppliersEvent()),
          child: ListView.builder(
            controller: scrollController,
            itemCount:
                state.paginationInfo?.hasNextPage == true
                    ? state.suppliers.length + 1
                    : state.suppliers.length,
            itemBuilder: (context, index) {
              if (index >= state.suppliers.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final supplier = state.suppliers[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SupplierCard(supplier: supplier),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (_) => BlocProvider.value(
                value: BlocProvider.of<SupplierViewModel>(context),
                child: const SupplierFormDialog(),
              ),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Create Supplier'),
    );
  }
}
