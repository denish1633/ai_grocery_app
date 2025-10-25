import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
        "product_code": product.code,
        "quantity": quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product']),
        quantity: json['quantity'] ?? 1,
      );
}

class Cart {
  List<CartItem> items;
  Cart({List<CartItem>? items}) : items = items ?? [];

  double get total => items.fold(0, (sum, i) => sum + i.subtotal);

  Map<String, dynamic> toJson() => {
        "items": items.map((i) => i.toJson()).toList(),
      };

  factory Cart.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List?)
            ?.map((e) => CartItem.fromJson(e))
            .toList() ??
        [];
    return Cart(items: items);
  }
}
