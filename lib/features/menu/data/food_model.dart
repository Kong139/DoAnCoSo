class Food {
  final int id;
  final String name;
  final String image;
  final double price;
  final String category;

  Food({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });

  // Chuyển từ JSON sang Food object
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: int.tryParse(json['id'].toString()) ?? 0, // Tránh lỗi nếu id bị null
      name: json['name'] ?? 'Chưa có tên', // Đặt giá trị mặc định
      image: json['image'] ?? '', // Tránh lỗi khi ảnh bị null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Tránh lỗi nếu price null
      category: json['category'] ?? 'Khác', // Đặt giá trị mặc định
    );
  }

  // Chuyển từ Food object sang JSON (dùng khi gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'category': category,
    };
  }
}
