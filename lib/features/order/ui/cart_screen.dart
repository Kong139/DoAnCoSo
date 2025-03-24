import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../order/logic/order_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Giỏ hàng")),
      body: orderProvider.cartItems.isEmpty
          ? Center(child: Text("Giỏ hàng trống"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orderProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = orderProvider.cartItems[index];
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          orderProvider.updateQuantity(item.food.id, item.quantity - 1);
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          orderProvider.updateQuantity(item.food.id, item.quantity + 1);
                        },
                      ),
                    ],
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
                  "Tổng tiền: \$${orderProvider.totalCartPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    orderProvider.placeOrder();
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
