import 'package:flutter/material.dart';
import '../../menu/data/food_model.dart';

class OrderItem {
  final Food food;
  int quantity;

  OrderItem({required this.food, required this.quantity});
}

class OrderProvider with ChangeNotifier {
  final Map<int, OrderItem> _order = {}; // Dùng food.id làm key

  Map<int, OrderItem> get order => _order;

  void addToOrder(Food food, [int quantity = 1]) {
    if (_order.containsKey(food.id)) {
      _order[food.id]!.quantity += quantity;
    } else {
      _order[food.id] = OrderItem(food: food, quantity: quantity);
    }
    notifyListeners();
  }

  void removeFromOrder(Food food) {
    if (_order.containsKey(food.id)) {
      if (_order[food.id]!.quantity > 1) {
        _order[food.id]!.quantity--;
      } else {
        _order.remove(food.id);
      }
      notifyListeners();
    }
  }

  void clearOrder() {
    _order.clear();
    notifyListeners();
  }

  double getTotalPrice() {
    return _order.values.fold(0, (total, item) => total + (item.food.price * item.quantity));
  }
}
