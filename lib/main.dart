import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/menu/data/menu_repository.dart';
import 'features/menu/logic/menu_provider.dart';
import 'features/order/logic/order_provider.dart';
import 'features/account/logic/auth_provider.dart';
import 'main_screen.dart';
import 'features/account/ui/login_screen.dart';
import 'features/order/data/order_repository.dart'; // Import OrderRepository

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider(MenuRepository())),
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ProxyProvider<AuthProvider, OrderRepository>(
          update: (context, authProvider, previous) => OrderRepository(authProvider),
        ),
        ChangeNotifierProxyProvider<OrderRepository, OrderProvider>(
          create: (context) => OrderProvider(Provider.of<OrderRepository>(context, listen: false)),
          update: (context, orderRepository, previous) => OrderProvider(orderRepository),
        ),
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
          if (authProvider.isAuthenticated) {
            return MainScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}