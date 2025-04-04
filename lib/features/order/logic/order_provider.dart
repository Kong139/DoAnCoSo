// order_provider.dart
import 'package:flutter/material.dart';
import '../../menu/data/food_model.dart';
import '../../order/data/order_model.dart';
import '../../order/data/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderItem> _cartItems = [];
  final List<OrderItem> _orderedItems = [];
  List<Order> _orderHistory = []; // Sử dụng List<Order>
  String? _authToken;
  final OrderRepository _orderRepository = OrderRepository(); // Khởi tạo repository

  List<OrderItem> get cartItems => _cartItems;
  List<OrderItem> get orderedItems => _orderedItems;
  List<Order> get orderHistory => _orderHistory; // Trả về List<Order>

  double get totalCartPrice => _cartItems.fold(
      0, (total, item) => total + (item.food.price * item.quantity));

  double get totalOrderPrice => _orderedItems.fold(
      0, (total, item) => total + (item.food.price * item.quantity));

  OrderProvider() {
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('token');
    notifyListeners();
  }

  void updateAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  void addToCart(Food food, int quantity) {
    final index = _cartItems.indexWhere((item) => item.food.id == food.id);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(OrderItem(food: food, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(int foodId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.food.id == foodId);
    if (index >= 0) {
      if (newQuantity > 0) {
        _cartItems[index].quantity = newQuantity;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  Future<void> placeOrder() async {
    if (_cartItems.isEmpty) return;

    try {
      await _orderRepository.placeOrder(_cartItems);
      _orderedItems.addAll(_cartItems);
      _cartItems.clear();
      notifyListeners();
      print('Order placed successfully!');
    } catch (e) {
      print('Error placing order: $e');
      // Handle error appropriately, e.g., show a snackbar
    }
  }

  Future<void> fetchOrderHistory() async {
    if (_authToken == null) return;

    try {
      _orderHistory = await _orderRepository.fetchOrderHistory();
      _orderHistory.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      notifyListeners();
    } catch (e) {
      print('Error fetching order history: $e');
      // Handle error appropriately
    }
  }
}