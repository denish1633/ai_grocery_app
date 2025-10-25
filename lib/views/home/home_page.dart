import 'package:ai_grocery_app/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_grocery_app/controllers/product_controller.dart';
import 'package:ai_grocery_app/views/cart/cart_page.dart';
import 'package:ai_grocery_app/views/home/wishlist_page.dart';
import 'package:ai_grocery_app/views/home/find_product.dart';
import 'package:ai_grocery_app/widgets/banner_carousel.dart';
import 'package:ai_grocery_app/widgets/bottom_nav.dart';
import 'package:ai_grocery_app/widgets/product_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ✅ Use global instance instead of re-putting (since it’s already in main.dart)
  final ProductController controller = Get.find<ProductController>();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ Navigation pages
    final pages = [
      _buildHomePage(),
      const FindProductPage(),
      const WishlistPage(),
      CartPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
      ),
    );
  }

  /// 🏠 Home Page Section
  Widget _buildHomePage() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: controller.fetchAllProducts,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          children: [
            const BannerCarousel(),
            const SizedBox(height: 15),
            ProductRow(title: 'Fresh Vegetables', products: controller.vegetables),
            const SizedBox(height: 10),
            ProductRow(title: 'Fresh Fruits', products: controller.fruits),
          ],
        ),
      );
    });
  }
}
