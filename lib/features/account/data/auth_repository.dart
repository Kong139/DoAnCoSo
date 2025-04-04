import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String baseUrl = 'http://restaurant-api.eba-wzh62pas.us-east-1.elasticbeanstalk.com/api/auth';

  // Hàm đăng ký người dùng
  Future<void> register(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 201) {
      // Nếu đăng ký thành công, có thể tự động đăng nhập sau này
      return;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Đăng ký thất bại');
    }
  }

  // Hàm đăng nhập: trả về thông tin user và lưu token
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Lưu token vào SharedPreferences
      await saveToken(data['token']);
      return data;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Đăng nhập thất bại');
    }
  }

  // Hàm đăng xuất: xóa token khỏi SharedPreferences
  Future<void> logout() async {
    await removeToken();
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved: $token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print('Token removed');
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Token loaded from SharedPreferences: $token');
    return token;
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('No token found');
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/validate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        print('Token is valid');
        return true;
      } else {
        // Nếu token không hợp lệ, xóa nó khỏi SharedPreferences
        await prefs.remove('token');
        print('Token invalid, removed from SharedPreferences');
        return false;
      }
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  // Lấy thông tin người dùng từ token
  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      return null;
    }
    try {
      // Token dạng JWT có cấu trúc: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }
      final payload = parts[1];
      // Chuẩn hóa chuỗi base64 nếu thiếu padding
      String normalized = base64.normalize(payload);
      // Giải mã payload
      final payloadDecoded = utf8.decode(base64Url.decode(normalized));
      final payloadJson = jsonDecode(payloadDecoded);
      return payloadJson;
    } catch (e) {
      return null;
    }
  }


}
