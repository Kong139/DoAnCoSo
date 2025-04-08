import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/menu/data/menu_repository.dart';
import 'features/menu/logic/menu_provider.dart';
import 'features/order/logic/order_provider.dart';
import 'features/account/logic/auth_provider.dart';
import 'main_screen.dart';
import 'features/account/ui/login_screen.dart';
import 'features/order/data/order_repository.dart';
import 'splash_provider.dart';
import 'splash_screen.dart';
import 'navigation_provider.dart';
import 'features/account/logic/login_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider(MenuRepository())),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => SplashProvider(Provider.of<AuthProvider>(context, listen: false)),
        ),
        ProxyProvider<AuthProvider, OrderRepository>(
          update: (context, authProvider, previous) => OrderRepository(authProvider),
        ),
        ChangeNotifierProxyProvider<OrderRepository, OrderProvider>(
          create: (context) => OrderProvider(Provider.of<OrderRepository>(context, listen: false)),
          update: (context, orderRepository, previous) => OrderProvider(orderRepository),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
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
      home: Consumer<SplashProvider>(
        builder: (context, splashProvider, child) {
          if (!splashProvider.isInitialized) {
            return SplashScreen();
          } else {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            return authProvider.isAuthenticated ? MainScreen() : LoginScreen();
          }
        },
      ),
    );
  }
}