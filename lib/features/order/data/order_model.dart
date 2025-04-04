// order_model.dart
import '../../menu/data/food_model.dart';

class OrderItem {
  final Food food;
  int quantity;

  OrderItem({required this.food, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'itemId': food.id,
      'quantity': quantity,
    };
  }
}

class Order {
  final String id;
  final String phone;
  final List<OrderItem> listItem;
  final DateTime orderDate;
  final DateTime? paymentDate;

  Order({
    required this.id,
    required this.phone,
    required this.listItem,
    required this.orderDate,
    this.paymentDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      phone: json['phone'],
      listItem: (json['listItem'] as List)
          .map((item) => OrderItem(
        food: Food(  // Tạo Food object từ itemId (cần thông tin food)
          id: item['itemId'],
          name: 'Unknown', // Thay bằng cách lấy tên món ăn nếu có
          image: '',       // Thay bằng cách lấy ảnh món ăn nếu có
          price: 0.0,      // Thay bằng cách lấy giá món ăn nếu có
          category: '',    // Thay bằng cách lấy category nếu có
        ),
        quantity: item['quantity'],
      ))
          .toList(),
      orderDate: DateTime.parse(json['orderDate']),
      paymentDate: json['paymentDate'] != null ? DateTime.parse(json['paymentDate']) : null,
    );
  }
}