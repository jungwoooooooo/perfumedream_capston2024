import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model_product.dart';

class ProductProvider with ChangeNotifier {
  late CollectionReference productsReference;
  List<Product> products = [];
  List<Product> searchProduct = [];

  ProductProvider({reference}) {
    productsReference = reference ?? FirebaseFirestore.instance.collection('products');
  }

  Future<void> fetchProducts() async {
    products = await productsReference.get().then((QuerySnapshot results) {
      return results.docs.map((DocumentSnapshot document) {
        return Product.fromJson(document.data() as Map<String, Object?>);
      }).toList();
    });
    notifyListeners();
  }

  Future<void> search(String query) async {
    searchProduct = [];
    if (query.isEmpty) {
      return;
    }
    for (Product product in products) {
      if (product.productName != null && product.productName!.contains(query)) {
        searchProduct.add(product);
      }
    }
    notifyListeners();
  }
}
