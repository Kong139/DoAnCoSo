import 'dart:convert';
import 'package:http/http.dart' as http;
import 'food_model.dart';

class MenuRepository {
  final String apiUrl = "http://restaurant-api.eba-wzh62pas.us-east-1.elasticbeanstalk.com/api/menu";

  Future<List<Food>> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Food.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy thực đơn.');
      } else {
        throw Exception('Lỗi server (${response.statusCode}). Vui lòng thử lại.');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<Food?> getFoodById(int id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id')).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
        return Food.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // Hoặc throw Exception nếu muốn xử lý lỗi khác
      } else {
        throw Exception('Lỗi server (${response.statusCode}). Vui lòng thử lại.');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}