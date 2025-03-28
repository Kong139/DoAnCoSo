import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool get isAuthenticated => _token != null;
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  String? _username;
  String? get username => _username;

  Future<void> register(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://restaurant-api.eba-wzh62pas.us-east-1.elasticbeanstalk.com/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      if (response.statusCode == 201) {
        await login(phone, password); // Đăng ký xong tự động đăng nhập
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<void> login(String phone, String password) async {
      final response = await http.post(
        Uri.parse('http://restaurant-api.eba-wzh62pas.us-east-1.elasticbeanstalk.com/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _phoneNumber = data['phone'];
        _username = data['name'];

        await _saveToken(_token!);
        notifyListeners();
        print("Đăng nhập thành công, token: $_token, name: $_username, phone: $_phoneNumber");
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Đăng nhập thất bại');
      }
  }

  Future<void> logout() async {
    _token = null;
    await _removeToken();
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }
}
