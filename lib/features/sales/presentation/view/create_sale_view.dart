import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/sales/presentation/view/tabs/current_sale_tab.dart';
import 'package:quickstock/features/sales/presentation/view/tabs/product_selection_tab.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_state.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_view_model.dart';
import 'package:quickstock/features/sales/presentation/widget/sale_summary_footer.dart';

class CreateSaleView extends StatelessWidget {
  const CreateSaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<CreateSaleViewModel>()
                ..add(const LoadProductsEvent()),
      child: BlocListener<CreateSaleViewModel, CreateSaleState>(
        listener: (context, state) {
          if (state.status == CreateSaleStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Sale created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.of(context).pop();
          } else if (state.status == CreateSaleStatus.failure) {
            final rawErrorMessage =
                state.errorMessage ?? 'An unknown error occurred.';

            String customMessage;
            if (rawErrorMessage.toLowerCase().contains('insufficient stock')) {
              customMessage =
                  'Out of Stock! Please check item quantities and try again.';
            } else if (rawErrorMessage.toLowerCase().contains('network')) {
              customMessage = 'Network error. Please check your connection.';
            } else {
              customMessage = 'Sale failed. Please try again.';
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(customMessage),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('New Sale / POS'),
              bottom: TabBar(
                tabs: [
                  const Tab(
                    icon: Icon(Icons.grid_view_rounded),
                    text: 'Products',
                  ),
                  BlocBuilder<CreateSaleViewModel, CreateSaleState>(
                    builder: (context, state) {
                      return Badge(
                        label: Text(state.cartItems.length.toString()),
                        isLabelVisible: state.cartItems.isNotEmpty,
                        child: const Tab(
                          icon: Icon(Icons.shopping_cart_outlined),
                          text: 'Current Sale',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: [ProductSelectionTab(), CurrentSaleTab()],
            ),
            bottomNavigationBar: const SaleSummaryFooter(),
          ),
        ),
      ),
    );
  }
}
