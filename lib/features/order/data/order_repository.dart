import 'dart:convert';
import 'package:http/http.dart' as http;
import 'order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository {
  final String baseUrl =
      'http://restaurant-api.eba-wzh62pas.us-east-1.elasticbeanstalk.com/api';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> placeOrder(List<OrderItem> items) async {
    final url = Uri.parse('$baseUrl/orders');
    final token = await _getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'listItem': items.map((item) => item.toJson()).toList()});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to place order: ${response.statusCode}');
    }
  }

  Future<List<Order>> fetchOrderHistory() async {
    final url = Uri.parse('$baseUrl/orders');
    final token = await _getAuthToken();
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch order history: ${response.statusCode}');
    }
  }
}