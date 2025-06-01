import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickstock/view/pages/home_view.dart';
import 'package:quickstock/view/pages/inventory_view.dart';
import 'package:quickstock/view/pages/profile_view.dart';
import 'package:quickstock/view/pages/setting_view.dart';
import 'package:quickstock/view/pages/transactions_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  static final List<Widget> pages = [
    HomeView(),
    InventoryView(),
    TransactionsView(),
    ProfileView(),
    SettingView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: IndexedStack(index: selectedIndex, children: pages)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.black, size: 30),
        selectedLabelStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.boxesStacked),
            label: "Inventory",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/transaction.png",
              width: 24,
              height: 24,
            ),
            label: "Transaction",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}
