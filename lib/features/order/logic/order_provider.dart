// order_provider.dart
import 'package:flutter/material.dart';
import '../../menu/data/food_model.dart';
import '../../order/data/order_model.dart';
import '../../order/data/order_repository.dart';
import '../../account/logic/auth_provider.dart'; // Import AuthProvider

class OrderProvider with ChangeNotifier {
  final List<OrderItem> _cartItems = [];
  final List<OrderItem> _orderedItems = [];
  List<Order> _orderHistory = [];

  final OrderRepository _orderRepository;

  List<OrderItem> get cartItems => _cartItems;
  List<OrderItem> get orderedItems => _orderedItems;
  List<Order> get orderHistory => _orderHistory;

  double get totalCartPrice => _cartItems.fold(
      0, (total, item) => total + (item.food.price * item.quantity));

  double get totalOrderPrice => _orderedItems.fold(
      0, (total, item) => total + (item.food.price * item.quantity));

  OrderProvider(this._orderRepository);

  void addToCart(Food food, int quantity, {String? notes}) {
    final index = _cartItems.indexWhere((item) => item.food.id == food.id && item.notes == notes); // Tìm kiếm cả theo ID món và ghi chú
    if (index >= 0) {
      // Nếu món đã có trong giỏ với cùng ghi chú, cộng dồn số lượng
      _cartItems[index].quantity += quantity;
    } else {
      // Nếu món chưa có hoặc có ghi chú khác, thêm một OrderItem mới
      _cartItems.add(OrderItem(food: food, quantity: quantity, notes: notes));
    }
    notifyListeners();
  }

  void updateQuantity(int foodId, int newQuantity, {String? notes}) {
    final index = _cartItems.indexWhere((item) => item.food.id == foodId && item.notes == notes);
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
    try {
      _orderHistory = await _orderRepository.fetchOrderHistory();
      print('Fetched order history: $_orderHistory');
      _orderHistory.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      notifyListeners();
    } catch (e) {
      print('Error fetching order history: $e');
      // Handle error appropriately
    }
  }
}