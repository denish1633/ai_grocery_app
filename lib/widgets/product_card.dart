import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.put(WishlistController());
    final CartController cartController = Get.find<CartController>();

    final imageUrl = product.imageUrl ?? '';
    final name = product.name ?? 'Unnamed Product';
    final quantityLabel = '1 pcs, Priceg';
    final price = product.price ?? 0.0;

    return Stack(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🖼 Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported, size: 60),
                        )
                      : const Icon(Icons.image_not_supported, size: 60),
                ),

                const SizedBox(height: 10),

                // 🏷 Product Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // 📦 Quantity label
                Text(
                  quantityLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // 💵 Price + Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 💰 Price
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // 🛒 Add Button
                    Obx(() {
                      final inCart = cartController.items
                          .any((i) => i.product.code == product.code);

                      return InkWell(
                        onTap: () {
                          if (!inCart) {
                            cartController.addToCart(product);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: inCart ? Colors.grey : Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            inCart ? Icons.check : Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
             
              ],
            ),
          ),
        ),

        // ❤️ Wishlist Icon
        Positioned(
          top: 8,
          right: 8,
          child: Obx(() {
            final isLiked = wishlistController.isWishlisted(product);
            return GestureDetector(
              onTap: () => wishlistController.toggleWishlist(product),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 20,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
