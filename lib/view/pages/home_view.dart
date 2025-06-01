import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickstock/common/dashboard_card.dart';
import 'package:quickstock/common/quick_action_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardCard(
              title: 'Total Revenue',
              value: 'Rs 50,000',
              icon: FontAwesomeIcons.dollarSign,
              color: Colors.green,
            ),
            const SizedBox(height: 10),

            DashboardCard(
              title: 'Total Sales',
              value: '350',
              icon: FontAwesomeIcons.cartShopping,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),

            DashboardCard(
              title: 'Stock Value',
              value: 'Rs 8,500',
              icon: FontAwesomeIcons.boxesStacked,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),

            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                QuickActionButton(
                  icon: FontAwesomeIcons.plus,
                  label: 'Add Sale',
                  color: Colors.blueAccent,
                  onPressed: () {},
                ),
                QuickActionButton(
                  icon: FontAwesomeIcons.cartPlus,
                  label: 'Add Purchase',
                  color: Colors.greenAccent,
                  onPressed: () {},
                ),
                QuickActionButton(
                  icon: FontAwesomeIcons.triangleExclamation,
                  label: 'Low Stock',
                  color: Colors.redAccent,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
