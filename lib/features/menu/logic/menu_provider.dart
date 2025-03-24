import 'package:flutter/material.dart';
import '../data/food_model.dart';
import '../data/menu_repository.dart';

class MenuProvider with ChangeNotifier {
  final MenuRepository menuRepository;
  List<Food> _menu = [];
  bool _isLoading = false;
  String _selectedCategory = "Tất cả"; // Mặc định hiển thị tất cả món
  String? _errorMessage;

  MenuProvider(this.menuRepository);

  List<Food> get menu => _selectedCategory == "Tất cả"
      ? _menu
      : _menu.where((food) => food.category == _selectedCategory).toList();

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage; // Thêm getter để UI hiển thị lỗi

  Future<void> loadMenu() async {
    if (_isLoading) return; // Tránh gọi nhiều lần khi đang tải

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Food> fetchedMenu = await menuRepository.fetchMenu();
      if (fetchedMenu.isNotEmpty) {
        _menu = fetchedMenu;
      } else {
        _errorMessage = "Không có món ăn nào.";
      }
    } catch (e) {
      _errorMessage = "Lỗi tải menu: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }
}
