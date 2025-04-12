// order_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'order_model.dart';
import '../../account/logic/auth_provider.dart'; // Import AuthProvider

class OrderRepository {
  final String baseUrl =
      'http://app-api-env.eba-u24nfued.us-east-1.elasticbeanstalk.com/api';
  final AuthProvider authProvider; // Thêm AuthProvider

  OrderRepository(this.authProvider); // Constructor nhận AuthProvider

  Future<void> placeOrder(List<OrderItem> items) async {
    final url = Uri.parse('$baseUrl/orders');
    final token = authProvider.authToken; // Truy cập token từ AuthProvider
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
    final token = authProvider.authToken;
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Future<Order>> orderFutures = data.map((json) => Order.fromJson(json)).toList();
      final List<Order> orders = await Future.wait(orderFutures);
      return orders;
    } else {
      throw Exception('Failed to fetch order history: ${response.statusCode}');
    }
  }
}