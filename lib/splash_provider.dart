import 'package:flutter/material.dart';
import '../features/account/logic/auth_provider.dart';

class SplashProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  SplashProvider(this._authProvider) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _authProvider.loadToken();
    _isInitialized = true;
    notifyListeners();
  }
}