import 'package:flutter/material.dart';

class QuantityProvider with ChangeNotifier {
  int _quantity = 1;
  String? _notes;

  int get quantity => _quantity;
  String? get notes => _notes;

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void updateNotes(String notes) {
    _notes = notes;
  }
}