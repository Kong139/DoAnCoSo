import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/menu/ui/menu_screen.dart';
import 'features/order/ui/cart_screen.dart';
import 'features/order/ui/order_screen.dart';
import 'features/account/ui/account_screen.dart';
import 'features/account/logic/auth_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MenuScreen(),
    CartScreen(),
    OrderScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
