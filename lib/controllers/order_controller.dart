import 'package:get/get.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = true.obs;

  final OrderService _service = OrderService();

  Future<void> fetchOrders(int userId) async {
    try {
      isLoading.value = true;
      final fetchedOrders = await _service.getOrders(userId);
      orders.assignAll(fetchedOrders);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
