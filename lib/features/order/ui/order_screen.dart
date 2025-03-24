import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../order/logic/order_provider.dart';
import '../../menu/data/food_model.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Đơn hàng")),
      body: orderProvider.order.isEmpty
          ? Center(child: Text("Giỏ hàng trống"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orderProvider.order.length,
              itemBuilder: (context, index) {
                final OrderItem orderItem = orderProvider.order.values.elementAt(index);
                final Food food = orderItem.food;
                final int quantity = orderItem.quantity;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(food.image, width: 50, height: 50),
                    title: Text(food.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text("\$${food.price.toStringAsFixed(2)} x $quantity"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            orderProvider.removeFromOrder(food);
                          },
                        ),
                        Text('$quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            orderProvider.addToOrder(food);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Tổng tiền: \$${orderProvider.getTotalPrice().toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý đặt hàng
                    orderProvider.clearOrder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đặt hàng thành công!")),
                    );
                  },
                  child: Text("Đặt hàng"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
