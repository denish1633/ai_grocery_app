import 'package:get/get.dart';
import 'package:ai_grocery_app/models/product.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service = ProductService();

  var vegetables = <Product>[].obs;
  var fruits = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAllProducts();
    super.onInit();
  }

  Future<void> fetchAllProducts() async {
    isLoading(true);
    try {
      vegetables.value = await _service.fetchProducts('juice');
      fruits.value = await _service.fetchProducts('fruits');
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
