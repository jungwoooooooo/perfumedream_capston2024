import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/model_product.dart';
import '../models/product_model.dart';

class ProductService {
  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/product/category?categoryId=$categoryId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch products: $e');
      rethrow;
    }
  }
}
