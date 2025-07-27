import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quickstock/core/common/dashboard_card.dart';
import 'package:quickstock/core/common/quick_action_button.dart';

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
              value: 'Rs 80,500',
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
            const SizedBox(height: 24),

            const Text(
              'Stock Levels',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Rice');
                            case 1:
                              return Text('Flour');
                            case 2:
                              return Text('Oil');
                            case 3:
                              return Text('Milk');
                            case 4:
                              return Text('Eggs');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: 50,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: 30,
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: 20,
                          color: Colors.orangeAccent,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: 45,
                          color: Colors.purpleAccent,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: 15,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Top-Selling Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(
                  leading: Icon(FontAwesomeIcons.boxOpen, color: Colors.teal),
                  title: Text('Rice'),
                  trailing: Text('120 sales'),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.boxOpen, color: Colors.teal),
                  title: Text('Oil'),
                  trailing: Text('90 sales'),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.boxOpen, color: Colors.teal),
                  title: Text('Milk'),
                  trailing: Text('80 sales'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
