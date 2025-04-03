import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../order/logic/order_provider.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Đơn hàng")),
      body: orderProvider.orderedItems.isEmpty
          ? Center(child: Text("Chưa có đơn hàng nào"))
          : ListView.builder(
        itemCount: orderProvider.orderedItems.length,
        itemBuilder: (context, index) {
          final item = orderProvider.orderedItems[index];
          return ListTile(
            leading: Image.network(
              item.food.image,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, size: 50);
              },
            ),
            title: Text(item.food.name),
            subtitle: Text("Giá: \$${item.food.price}"),
            trailing: Text('Số lượng: ${item.quantity}'),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 70.0),
          child: Text(
            "Tổng tiền: \$${orderProvider.totalOrderPrice.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
