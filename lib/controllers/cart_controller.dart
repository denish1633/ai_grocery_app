import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../controllers/auth_controller.dart';

class CartController extends GetxController {
  final _storage = GetStorage();
  final CartService _service = CartService();
  final AuthController authController = Get.find<AuthController>();

  var items = <CartItem>[].obs;
  int get userId => authController.user.value?.id ?? 0;

  @override
  void onInit() {
    super.onInit();
    _loadLocal();
  }

  double get total => items.fold(0, (s, i) => s + i.subtotal);

  /// ✅ Add product or increase quantity
  Future<void> addToCart(Product product) async {
    final existing = items.firstWhereOrNull((i) => i.product.code == product.code);
    if (existing != null) {
      existing.quantity++;
    } else {
      items.add(CartItem(product: product));
    }
    items.refresh();
    await _save();
  }

  /// ❌ Remove product completely
  Future<void> removeFromCart(Product product) async {
    items.removeWhere((i) => i.product.code == product.code);
    items.refresh();
    await _save();
  }

  /// 🔄 Decrease quantity or remove if zero
  Future<void> decreaseQuantity(Product product) async {
    final existing = items.firstWhereOrNull((i) => i.product.code == product.code);
    if (existing != null) {
      if (existing.quantity > 1) {
        existing.quantity--;
      } else {
        items.remove(existing);
      }
      items.refresh();
      await _save();
    }
  }

  /// 🧹 Clear all items
  Future<void> clearCart() async {
    items.clear();
    _storage.remove('cart');
    await _save();
  }

  /// 💾 Save to local + backend
  Future<void> _save() async {
    final cart = Cart(items: items);
    _storage.write('cart', cart.toJson());
    if (userId != 0) {
      await _service.saveCart(userId, items);
    }
  }

  /// 📦 Load cart from local storage
  void _loadLocal() {
    final data = _storage.read('cart');
    if (data != null) {
      try {
        final cart = Cart.fromJson(Map<String, dynamic>.from(data));
        items.assignAll(cart.items);
      } catch (_) {
        items.clear();
      }
    }
  }

  /// 🛒 Checkout
  Future<void> checkout() async {
    if (userId == 0) return;
    await _service.checkoutCart(userId);
    await clearCart();
  }
}
