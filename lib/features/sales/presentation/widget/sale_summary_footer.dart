import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_state.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_view_model.dart';

class SaleSummaryFooter extends StatelessWidget {
  const SaleSummaryFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CreateSaleViewModel, CreateSaleState>(
      buildWhen:
          (previous, current) =>
              previous.cartTotal != current.cartTotal ||
              previous.paymentMethod != current.paymentMethod ||
              previous.status != current.status,
      builder: (context, state) {
        final formattedTotal = NumberFormat.currency(
          symbol: 'रु ',
          decimalDigits: 2,
        ).format(state.cartTotal);

        final isCartEmpty = state.cartItems.isEmpty;
        final isSubmitting = state.status == CreateSaleStatus.submitting;

        return Container(
          padding: const EdgeInsets.all(
            16.0,
          ).copyWith(bottom: 16.0 + MediaQuery.of(context).viewPadding.bottom),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(
              top: BorderSide(color: theme.dividerColor, width: 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOTAL', style: theme.textTheme.labelMedium),
                      Text(
                        formattedTotal,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: state.paymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'Payment',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        context.read<CreateSaleViewModel>().add(
                          PaymentMethodChangedEvent(paymentMethod: newValue),
                        );
                      },
                      items: const [
                        DropdownMenuItem(value: 'cash', child: Text('Cash')),
                        DropdownMenuItem(
                          value: 'online',
                          child: Text('Online'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isCartEmpty || isSubmitting
                          ? null
                          : () {
                            context.read<CreateSaleViewModel>().add(
                              const SubmitSaleEvent(),
                            );
                          },
                  child:
                      isSubmitting
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Complete Sale'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
