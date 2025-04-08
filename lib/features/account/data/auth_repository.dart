import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String baseUrl = 'http://restaurant-api.eba-wzh62pas.us-east-1.elasticbeanstalk.com/api/auth';

// Hàm đăng ký người dùng
  Future<void> register(String name, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'phone': phone, 'password': password}),
      );

      if (response.statusCode == 201) {
        // Đăng ký thành công, không cần làm gì thêm ở đây vì hàm trả về void
        return;
      } else {
        // Đăng ký thất bại
        final data = jsonDecode(response.body);
        final errorMessage = data['message'] ?? 'Đăng ký thất bại'; // Lấy thông báo lỗi từ server
        throw Exception(errorMessage); // Ném ra ngoại lệ để thông báo lỗi cho lớp trên
      }
    } catch (e) {
      // Bắt lỗi nếu có bất kỳ ngoại lệ nào xảy ra (ví dụ: lỗi mạng)
      print('Lỗi đăng ký: $e'); // In lỗi ra console để debug
      throw Exception('Đăng ký thất bại: $e'); // Ném lại ngoại lệ để thông báo lỗi cho lớp trên
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
      await saveToken(data['token']);
      return data;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Đăng nhập thất bại');
    }
  }

  // Đổi mật khẩu
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Chưa đăng nhập');

    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'oldPassword': currentPassword, // <- Sửa ở đây
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      print('Đổi mật khẩu thành công');
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Đổi mật khẩu thất bại');
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
    return prefs.getString('token');
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
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final payloadDecoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(payloadDecoded);
    } catch (e) {
      return null;
    }
  }
}
