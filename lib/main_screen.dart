import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/menu/ui/menu_screen.dart';
import 'features/order/ui/cart_screen.dart';
import 'features/order/ui/order_screen.dart';
import 'features/account/ui/account_screen.dart';
import 'navigation_provider.dart';

class MainScreen extends StatelessWidget {
  final List<Widget> _screens = [
    MenuScreen(),
    CartScreen(),
    OrderScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      body: _screens[navigationProvider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.selectedIndex,
        onTap: (index) {
          navigationProvider.setSelectedIndex(index);
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Giỏ hàng"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Đơn hàng"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
    );
  }
}