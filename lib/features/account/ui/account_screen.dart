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
    _userInfoFuture =
        Provider.of<AuthProvider>(context, listen: false).fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: authProvider.isAuthenticated
          ? _buildAccountInfo(context)
          : _buildLoginButton(context),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return _buildLoginButton(context);
        } else {
          final userInfo = snapshot.data!;
          final username = userInfo['name'] ?? "Không có tên";
          final phoneNumber = userInfo['phone'] ?? "Chưa đăng nhập";

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoTile("👤  Tên người dùng", username),
                const SizedBox(height: 20),
                _infoTile("📱  Số điện thoại", phoneNumber),
                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: () => _showChangePasswordDialog(context),
                  icon: const Icon(Icons.lock),
                  label: const Text("Đổi mật khẩu"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        icon: const Icon(Icons.login),
        label: const Text("Đăng nhập"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                title: const Text("Đổi mật khẩu"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Mật khẩu hiện tại"),
                    ),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Mật khẩu mới"),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Hủy"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .changePassword(
                          currentPasswordController.text,
                          newPasswordController.text,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Đổi mật khẩu thành công")),
                        );
                      } catch (e) {
                        if (e.toString().contains("Mật khẩu cũ không đúng")) {
                          setState(() {
                            errorMessage = "Nhập sai mật khẩu cũ";
                          });
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                "Đổi mật khẩu thất bại: $e")),
                          );
                        }
                      }
                    },
                    child: const Text("Xác nhận"),
                  ),
                ],
              ),
        );
      },
    );
  }
}
