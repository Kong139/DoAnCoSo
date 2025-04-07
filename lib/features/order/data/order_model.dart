// order_model.dart
import '../../menu/data/food_model.dart';
import '../../menu/data/menu_repository.dart';

// order_model.dart
class OrderItem {
  final Food food;
  int quantity;
  String? notes;

  OrderItem({required this.food, required this.quantity, this.notes}); // Cập nhật constructor

  Map<String, dynamic> toJson() {
    return {
      'itemId': food.id,
      'quantity': quantity,
      'notes': notes,
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

  static Future<Order> fromJson(Map<String, dynamic> json) async {
    final menuRepository = MenuRepository();
    final listItem = await Future.wait(
      (json['listItem'] as List).map((item) async {
        final foodId = item['itemId'];
        final notes = item['notes'] as String?;
        Food? food;
        try {
          food = await menuRepository.getFoodById(foodId);
          if (food == null) {
            throw Exception('Food with id $foodId not found');
          }
        } catch (e) {
          print('Error fetching food with id $foodId: $e');
          throw e; // Re-throw the exception
        }
        return OrderItem(
            food: food ?? Food(id: foodId, name: 'Unknown', image: '', price: 0.0, category: ''),
            quantity: item['quantity'],
            notes: notes
        );
      }),
    );

    return Order(
      id: json['_id'],
      phone: json['phone'],
      listItem: listItem,
      orderDate: DateTime.parse(json['orderDate']),
      paymentDate: json['paymentDate'] != null ? DateTime.parse(json['paymentDate']) : null,
    );
  }
}