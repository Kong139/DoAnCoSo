import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../menu/data/food_model.dart';
import '../../order/logic/order_provider.dart';

class QuantitySelector extends StatefulWidget {
  final Food food;

  QuantitySelector({required this.food});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.food.price * _quantity;

    return AlertDialog(
      title: Text(widget.food.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            widget.food.image,
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
                onPressed: () {
                  setState(() {
                    if (_quantity > 1) _quantity--;
                  });
                },
              ),
              Text('$_quantity', style: TextStyle(fontSize: 18)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('Tổng: \$${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
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
            Provider.of<OrderProvider>(context, listen: false).addToOrder(widget.food, _quantity);

            // Hiển thị thông báo khi đặt món thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.food.name} x$_quantity đã được thêm vào giỏ hàng')),
            );

            Navigator.of(context).pop();
          },
          child: Text('Đặt món'),
        ),
      ],
    );
  }
}
