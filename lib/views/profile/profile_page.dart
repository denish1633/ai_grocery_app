import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';
// import '../controllers/order_controller.dart';
// import '../models/order.dart';

import 'package:ai_grocery_app/controllers/auth_controller.dart';
import 'package:ai_grocery_app/controllers/order_controller.dart';
import 'package:ai_grocery_app/models/order.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    final user = authController.user.value;

    if (user != null) {
      orderController.fetchOrders(user.id); // fetch orders
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 User Info
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.email ?? 'Guest User',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text('Member since 2025', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 🧾 Order History
            const Text('My Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() {
              if (orderController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (orderController.orders.isEmpty) {
                return const Text('No orders found.');
              } else {
                return Column(
                  children: orderController.orders.map((order) => _buildOrderCard(order)).toList(),
                );
              }
            }),

            const SizedBox(height: 24),
            // ⚙️ Settings Section
            const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildSettingsTile(Icons.edit, 'Edit Profile', () {}),
            _buildSettingsTile(Icons.location_on, 'Manage Addresses', () {}),
            _buildSettingsTile(Icons.notifications, 'Notifications', () {}),
            _buildSettingsTile(Icons.security, 'Privacy & Security', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'delivered':
        statusColor = Colors.green;
        break;
      case 'in transit':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: Colors.green),
        title: Text('Order #${order.id}'),
        subtitle: Text('Total: \$${order.total.toStringAsFixed(2)} • Items: ${order.items.length}'),
        trailing: Text(order.status, style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to log out?",
      confirm: ElevatedButton(
        onPressed: () {
          authController.logout();
          Get.offAllNamed('/login');
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text("Logout"),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      ),
    );
  }
}
