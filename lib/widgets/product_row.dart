import 'package:flutter/material.dart';
import 'package:ai_grocery_app/models/product.dart';
import 'package:ai_grocery_app/widgets/product_card.dart';

class ProductRow extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductRow({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏷 Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        // 🛒 Horizontal Product List
        SizedBox(
          height: 270, // fits product card content comfortably
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final product = products[index];
              return SizedBox(
                width: 160,
                child: ProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}
