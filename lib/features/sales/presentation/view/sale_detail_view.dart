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
    final formattedDate = DateFormat(
      'MMM d, yyyy hh:mm a',
    ).format(sale.saleDate);
    final formattedAmount = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(sale.totalAmount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('INVOICE', style: theme.textTheme.bodySmall),
                  Text(
                    sale.invoiceNumber,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(formattedDate, style: theme.textTheme.bodyMedium),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('TOTAL AMOUNT', style: theme.textTheme.bodySmall),
                  Text(
                    formattedAmount,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          // Payment Method
          Text('PAYMENT METHOD', style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Chip(
            label: Text(
              sale.paymentMethod.toUpperCase(),
              style: theme.textTheme.labelLarge,
            ),
            avatar: Icon(
              sale.paymentMethod == 'cash' ? Icons.money : Icons.credit_card,
            ),
          ),
          const Divider(height: 32),
          // Items Sold
          Text(
            'ITEMS SOLD (${sale.items.length})',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...sale.items.map((item) => SaleItemTile(item: item)),
        ],
      ),
    );
  }
}
