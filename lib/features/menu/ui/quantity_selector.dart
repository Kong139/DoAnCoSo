import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../menu/data/food_model.dart';
import '../../order/logic/order_provider.dart';
import '../logic/quantity_provider.dart';

class QuantitySelector extends StatelessWidget {
  final Food food;

  QuantitySelector({required this.food});

  @override
  Widget build(BuildContext context) {
    final quantityProvider = Provider.of<QuantityProvider>(context);
    double totalPrice = food.price * quantityProvider.quantity;

    return AlertDialog(
      title: Text(food.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              food.image,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: quantityProvider.decrementQuantity,
                ),
                Text('${quantityProvider.quantity}', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: quantityProvider.incrementQuantity,
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              // Không cần TextEditingController nữa
              decoration: InputDecoration(
                hintText: 'Thêm ghi chú (tùy chọn)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                quantityProvider.updateNotes(value);
              },
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Text('Tổng: \$${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<OrderProvider>(context, listen: false).addToCart(food, quantityProvider.quantity, notes: quantityProvider.notes);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${food.name} x${quantityProvider.quantity} đã được thêm vào giỏ hàng')),
            );
            Navigator.of(context).pop();
          },
          child: Text('Thêm vào giỏ'),
        ),
      ],
    );
  }
}