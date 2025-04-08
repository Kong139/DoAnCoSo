import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}