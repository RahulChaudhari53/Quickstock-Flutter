import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            // Revenue Card
            DashboardCard(
              title: 'Total Revenue',
              value: '\$25,000',
              icon: FontAwesomeIcons.dollarSign,
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            // Sales Card
            DashboardCard(
              title: 'Total Sales',
              value: '350',
              icon: FontAwesomeIcons.cartShopping,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Stock Summary Card
            DashboardCard(
              title: 'Stock Value',
              value: '\$8,500',
              icon: FontAwesomeIcons.boxesStacked,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),

            // Quick Actions
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
                  onPressed: () {
                    // TODO: Navigate to Add Sale screen
                  },
                ),
                QuickActionButton(
                  icon: FontAwesomeIcons.cartPlus,
                  label: 'Add Purchase',
                  color: Colors.greenAccent,
                  onPressed: () {
                    // TODO: Navigate to Add Purchase screen
                  },
                ),
                QuickActionButton(
                  icon: FontAwesomeIcons.triangleExclamation,
                  label: 'Low Stock',
                  color: Colors.redAccent,
                  onPressed: () {
                    // TODO: Navigate to Low Stock screen
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: onPressed,
    );
  }
}
