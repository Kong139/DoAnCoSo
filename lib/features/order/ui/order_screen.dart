// order_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../order/logic/order_provider.dart';
import '../../order/data/order_model.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Đơn hàng"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Đơn hàng hiện tại"),
              Tab(text: "Lịch sử đơn hàng"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCurrentOrderTab(context),
            _buildOrderHistoryTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentOrderTab(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return orderProvider.orderedItems.isEmpty
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
    );
  }

  Widget _buildOrderHistoryTab(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return orderProvider.orderHistory.isEmpty
        ? Center(child: Text("Không có lịch sử đơn hàng"))
        : ListView.builder(
      itemCount: orderProvider.orderHistory.length,
      itemBuilder: (context, index) {
        final order = orderProvider.orderHistory[index];
        final orderDate = order.orderDate;
        return ListTile(
          title: Text("Đơn hàng #${order.id.substring(0, 8)}"),
          subtitle: Text(
              "Ngày: ${orderDate.day}/${orderDate.month}/${orderDate.year} ${orderDate.hour}:${orderDate.minute}"),
          trailing: Text("Số món: ${order.listItem.length}"),
        );
      },
    );
  }
}