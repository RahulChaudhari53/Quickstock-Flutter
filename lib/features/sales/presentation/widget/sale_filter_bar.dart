import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_view_model.dart';

class SaleFilterBar extends StatefulWidget {
  const SaleFilterBar({super.key});

  @override
  State<SaleFilterBar> createState() => _SaleFilterBarState();
}

class _SaleFilterBarState extends State<SaleFilterBar> {
  final _searchController = TextEditingController();

  String _paymentMethod = '';
  String _sortBy = 'saleDate';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    final currentState = context.read<SalesHistoryViewModel>().state;
    _searchController.text = currentState.searchQuery ?? '';
    _paymentMethod = currentState.paymentMethod ?? '';
    _sortBy = currentState.sortBy;
    _sortOrder = currentState.sortOrder;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<SalesHistoryViewModel>().add(
      ApplySalesFilterEvent(
        search: _searchController.text,
        paymentMethod: _paymentMethod,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderColor =
        (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by Invoice #...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: _paymentMethod.isEmpty,
              onSelected: (selected) {
                if (selected) setState(() => _paymentMethod = '');
              },
              selectedColor: colorScheme.primary,
              showCheckmark: false,
              labelStyle: TextStyle(
                color:
                    _paymentMethod.isEmpty
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
              ),
              side:
                  _paymentMethod.isEmpty
                      ? BorderSide.none
                      : BorderSide(color: borderColor),
            ),
            ChoiceChip(
              label: const Text('Cash'),
              selected: _paymentMethod == 'cash',
              onSelected: (selected) {
                if (selected) setState(() => _paymentMethod = 'cash');
              },
              selectedColor: colorScheme.primary,
              showCheckmark: false,
              labelStyle: TextStyle(
                color:
                    _paymentMethod == 'cash'
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
              ),
              side:
                  _paymentMethod == 'cash'
                      ? BorderSide.none
                      : BorderSide(color: borderColor),
            ),
            ChoiceChip(
              label: const Text('Online'),
              selected: _paymentMethod == 'online',
              onSelected: (selected) {
                if (selected) setState(() => _paymentMethod = 'online');
              },
              selectedColor: colorScheme.primary,
              showCheckmark: false,
              labelStyle: TextStyle(
                color:
                    _paymentMethod == 'online'
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
              ),
              side:
                  _paymentMethod == 'online'
                      ? BorderSide.none
                      : BorderSide(color: borderColor),
            ),
            const SizedBox(width: 16),
            DropdownButtonFormField<String>(
              value: '$_sortBy:$_sortOrder',
              decoration: const InputDecoration(
                labelText: 'Sort by',
                // It will automatically use the default border from your theme
              ),
              onChanged: (String? newValue) {
                if (newValue == null) return;
                setState(() {
                  final parts = newValue.split(':');
                  _sortBy = parts[0];
                  _sortOrder = parts[1];
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'saleDate:desc',
                  child: Text('Newest First'),
                ),
                DropdownMenuItem(
                  value: 'saleDate:asc',
                  child: Text('Oldest First'),
                ),
                DropdownMenuItem(
                  value: 'totalAmount:desc',
                  child: Text('Amount (High-Low)'),
                ),
                DropdownMenuItem(
                  value: 'totalAmount:asc',
                  child: Text('Amount (Low-High)'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
