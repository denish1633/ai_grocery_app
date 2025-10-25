import 'package:ai_grocery_app/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart'; // ✅ Import
import 'utils/storage.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/home/home_page.dart';
import 'views/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.init();

  // ✅ Register all controllers BEFORE runApp
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<ProductController>(ProductController(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true); // ✅ Important
  Get.put<OrderController>(OrderController(), permanent: true); // ✅ Important

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indian Grocery Store',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}
