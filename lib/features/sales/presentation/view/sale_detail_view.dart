import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_detail/sale_detail_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_detail/sale_detail_state.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_detail/sale_detail_view_model.dart';
import 'package:quickstock/features/sales/presentation/widget/sale_item_tile.dart';

class SaleDetailView extends StatelessWidget {
  final String saleId;

  const SaleDetailView({super.key, required this.saleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<SaleDetailViewModel>()
                ..add(FetchSaleDetailEvent(saleId: saleId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sale Details')),
        body: BlocBuilder<SaleDetailViewModel, SaleDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case SaleDetailStatus.initial:
              case SaleDetailStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case SaleDetailStatus.failure:
                return Center(child: Text('Error: ${state.errorMessage}'));
              case SaleDetailStatus.success:
                if (state.sale == null) {
                  return const Center(
                    child: Text('Sale data is not available.'),
                  );
                }
                return _SaleDetailContent(sale: state.sale!);
            }
          },
        ),
      ),
    );
  }
}

class _SaleDetailContent extends StatelessWidget {
  final SaleEntity sale;
  const _SaleDetailContent({required this.sale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final borderColor =
        (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;

    final formattedDate = DateFormat('MMM d, yyyy').format(sale.saleDate);
    final formattedTime = DateFormat('hh:mm a').format(sale.saleDate);
    final formattedAmount = NumberFormat.currency(
      symbol: 'रु',
      decimalDigits: 2,
    ).format(sale.totalAmount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoColumn(textTheme, 'INVOICE', sale.invoiceNumber),
                  _buildInfoColumn(
                    textTheme,
                    'TOTAL',
                    formattedAmount,
                    valueColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    textTheme,
                    'Payment Method',
                    sale.paymentMethod.toUpperCase(),
                  ),
                  const Divider(),
                  _buildDetailRow(textTheme, 'Date', formattedDate),
                  const Divider(),
                  _buildDetailRow(textTheme, 'Time', formattedTime),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Items Sold (${sale.items.length})',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor),
            ),
            clipBehavior:
                Clip.antiAlias, 
            child: Column(
              children: List.generate(sale.items.length, (index) {
                final item = sale.items[index];
                return Column(
                  children: [
                    SaleItemTile(item: item),
                    if (index < sale.items.length - 1)
                      const Divider(height: 1, indent: 16),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    TextTheme textTheme,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(TextTheme textTheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyLarge?.copyWith(
              color: textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
