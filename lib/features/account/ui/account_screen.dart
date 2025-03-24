import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../account/logic/auth_provider.dart';
import '../ui/login_screen.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final phoneNumber = authProvider.phoneNumber ?? "Chưa đăng nhập";
    final username = authProvider.username ?? "Không có tên";

    return Scaffold(
      appBar: AppBar(title: Text("Tài khoản")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Tên người dùng:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              username,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              "Số điện thoại:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              phoneNumber,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text("Đăng xuất", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
