import 'package:flutter/material.dart';
import '../data/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  String? _token;
  String? _phoneNumber;
  String? _username;

  bool get isAuthenticated => _token != null;
  String? get phoneNumber => _phoneNumber;
  String? get username => _username;

  Future<void> register(String phone, String password) async {
    try {
      await _authRepository.register(phone, password);
      await login(phone, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> login(String phone, String password) async {
    try {
      final data = await _authRepository.login(phone, password);
      _token = data['token'];
      _phoneNumber = data['phone'];
      _username = data['name'];
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    _token = null;
    _phoneNumber = null;
    _username = null;
    await _authRepository.logout();
    notifyListeners();
  }

  // Load token và kiểm tra tính hợp lệ của nó
  Future<void> loadToken() async {
    _token = await _authRepository.loadToken();
    if (_token != null) {
      bool valid = await isTokenValid();
      if (!valid) {
        _token = null;
      }
    }
    notifyListeners();
  }

  // Kiểm tra token có hợp lệ không
  Future<bool> isTokenValid() async {
    return await _authRepository.isTokenValid();
  }

  Future<Map<String, dynamic>?> fetchUserInfo() async {
    final userInfo = await _authRepository.getUserInfo();
    if (userInfo != null) {
      _username = userInfo['name'] ?? _username;
      _phoneNumber = userInfo['phone'] ?? _phoneNumber;
      notifyListeners();
    }
    return userInfo;
  }
}
