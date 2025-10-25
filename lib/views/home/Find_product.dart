import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FindProductPage extends StatefulWidget {
  const FindProductPage({super.key});

  @override
  State<FindProductPage> createState() => _FindProductPageState();
}

class _FindProductPageState extends State<FindProductPage> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Fresh Fruits & Vegetables", "color": const Color(0xFFDFFFD8)},
    {"name": "Cooking Oil & Ghee", "color": const Color(0xFFFFF6BD)},
    {"name": "Meat & Fish", "color": const Color(0xFFFFD9C0)},
    {"name": "Bakery & Snacks", "color": const Color(0xFFE7D1FF)},
    {"name": "Dairy & Eggs", "color": const Color(0xFFFFE6E6)},
    {"name": "Beverages", "color": const Color(0xFFC5E3FF)},
  ];

  final String unsplashKey = "KKbmPU7Sp9eW9Bzeb4IDQk0jueve2pM1GkYjRZJh2Gg";

  /// Fetch Unsplash image based on category name
  Future<String> fetchImage(String query) async {
    try {
      final url =
          "https://api.unsplash.com/search/photos?page=1&per_page=1&query=$query&client_id=$unsplashKey";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          return data['results'][0]['urls']['regular'];
        }
      }
      return "https://via.placeholder.com/150";
    } catch (e) {
      debugPrint("Error fetching image: $e");
      return "https://via.placeholder.com/150";
    }
  }

  /// Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Find Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            // 🔍 Search bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search Store",
                  hintStyle: TextStyle(fontSize: 16),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🧱 Category Grid
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return FutureBuilder<String>(
                    future: fetchImage(category["name"]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return _buildLoadingTile(category);
                      }
                      return _buildCategoryTile(
                        context,
                        category,
                        snapshot.data!,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧩 Category card widget
  Widget _buildCategoryTile(
      BuildContext context, Map<String, dynamic> category, String imageUrl) {
    return GestureDetector(
      onTap: () {
        // Open category view (inline version)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailPage(categoryName: category["name"]),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: category["color"],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: category["color"], width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 70,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                category["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ⏳ Loading placeholder while image loads
  Widget _buildLoadingTile(Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        color: category["color"],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: category["color"], width: 1.5),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

/// ------------------------------
/// 🧭 Category Detail Placeholder
/// ------------------------------
class CategoryDetailPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // This can later display a ProductGrid for this category
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Products for $categoryName will appear here',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
