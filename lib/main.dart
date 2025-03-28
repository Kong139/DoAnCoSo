import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/menu/data/menu_repository.dart';
import 'features/menu/logic/menu_provider.dart';
import 'features/order/logic/order_provider.dart';
import 'features/account/logic/auth_provider.dart';
import 'main_screen.dart';
import 'features/account/ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadToken(); // Load token từ SharedPreferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider(MenuRepository())),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => authProvider),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isAuthenticated ? MainScreen() : LoginScreen();
        },
      ),
    );
  }
}
