import 'package:flutter/material.dart';
import '../../menu/data/food_model.dart';

class OrderItem {
  final Food food;
  int quantity;

  OrderItem({required this.food, required this.quantity});
}

class OrderProvider with ChangeNotifier {
  final List<OrderItem> _cartItems = [];
  final List<OrderItem> _orderedItems = [];

  List<OrderItem> get cartItems => _cartItems;
  List<OrderItem> get orderedItems => _orderedItems;

  double get totalCartPrice =>
      _cartItems.fold(0, (total, item) => total + (item.food.price * item.quantity));

  double get totalOrderPrice =>
      _orderedItems.fold(0, (total, item) => total + (item.food.price * item.quantity));

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

  void placeOrder() {
    _orderedItems.addAll(_cartItems);
    _cartItems.clear();
    notifyListeners();
  }
}
