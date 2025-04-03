import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../account/logic/auth_provider.dart';
import '../ui/login_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Map<String, dynamic>?> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    // Gọi fetchUserInfo() từ AuthProvider để lấy thông tin người dùng từ API
    _userInfoFuture = Provider.of<AuthProvider>(context, listen: false).fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tài khoản")),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị loading khi chờ dữ liệu
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiển thị lỗi nếu có sự cố khi tải dữ liệu
            return const Center(child: Text("Lỗi khi tải thông tin"));
          } else {
            // Nếu đã có dữ liệu, lấy thông tin người dùng từ API
            final userInfo = snapshot.data;
            final username = userInfo?['name'] ?? "Không có tên";
            final phoneNumber = userInfo?['phone'] ?? "Chưa đăng nhập";

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle, size: 100, color: Colors.blue),
                  const SizedBox(height: 20),
                  const Text(
                    "Tên người dùng:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    username,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Số điện thoại:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phoneNumber,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false).logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      "Đăng xuất",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
