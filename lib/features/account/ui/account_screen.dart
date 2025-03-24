import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tài khoản")),
      body: Center(child: Text("Thông tin tài khoản")),
    );
  }
}