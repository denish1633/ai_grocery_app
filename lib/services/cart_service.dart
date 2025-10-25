import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cart.dart';
import '../models/product.dart';
import 'package:ai_grocery_app/config/constants.dart';

class CartService {
  /// Save or update cart
  Future<void> saveCart(int userId, List<CartItem> items) async {
    final body = {
      "user_id": userId,
      "checkout_status": false,
      "products": items
          .map((i) => {
                "product_code": i.product.code,
                "quantity": i.quantity,
              })
          .toList(),
    };

    final url = Uri.parse('${Constants.apiUrl}/api/v1/cart/');
    print("POST $url");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to save cart: ${response.body}");
    }
  }

  /// Get user's cart
  Future<List<CartItem>> fetchCart(int userId) async {
    final url = Uri.parse('${Constants.apiUrl}/api/v1/cart/$userId');
    print("GET $url");
    final response = await http.get(url);
    if (response.statusCode != 200) throw Exception("Failed: ${response.body}");
    final data = jsonDecode(response.body);

    if (data is List && data.isNotEmpty) {
      final cart = data.first;
      final products = cart['products'] as List<dynamic>? ?? [];
      return products.map((p) {
        return CartItem(
          product: Product(
            code: p['product_code'] ?? '',
            name: p['name'] ?? 'Unknown',
            price: (p['price'] ?? 0).toDouble(),
            imageUrl: p['image_url'],
          ),
          quantity: p['quantity'] ?? 1,
        );
      }).toList();
    }
    return [];
  }

  /// Checkout cart
  Future<void> checkoutCart(int userId) async {
    final url = Uri.parse('${Constants.apiUrl}/api/v1/cart/$userId/checkout');
    print("POST $url");
    final response =
        await http.post(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      throw Exception("Checkout failed: ${response.body}");
    }
  }
}
