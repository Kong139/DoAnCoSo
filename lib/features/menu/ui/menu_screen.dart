import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/menu_provider.dart';
import '../../order/logic/order_provider.dart';
import '../data/food_model.dart';
import 'quantity_selector.dart';

class MenuScreen extends StatelessWidget {
  final List<String> categories = ["Tất cả", "Khai vị", "Món chính", "Đồ uống", "Món tráng miệng"];

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: true);

    // Gọi API khi mở màn hình, chỉ khi chưa có dữ liệu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (menuProvider.menu.isEmpty && !menuProvider.isLoading) {
        menuProvider.loadMenu();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("MENU")),
      body: Column(
        children: [
          // Thanh phân loại món ăn
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: menuProvider.selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        menuProvider.setCategory(category);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: menuProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : menuProvider.menu.isEmpty
                ? Center(
              child: Text(
                "Không có món ăn nào!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              itemCount: menuProvider.menu.length,
              itemBuilder: (context, index) {
                final Food food = menuProvider.menu[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      food.image,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                    title: Text(food.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text("\$${food.price.toStringAsFixed(2)}"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return QuantitySelector(food: food);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
