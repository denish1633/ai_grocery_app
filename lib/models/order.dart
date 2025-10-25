class OrderItem {
  final int productId;
  final int quantity;

  OrderItem({required this.productId, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }
}

class Order {
  final int id;
  final int userId;
  final double total;
  final String status;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.total,
    required this.status,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List)
        .map((itemJson) => OrderItem.fromJson(itemJson))
        .toList();

    return Order(
      id: json['id'],
      userId: json['user_id'],
      total: (json['total'] as num).toDouble(),
      status: json['status'],
      items: itemsList,
    );
  }
}
