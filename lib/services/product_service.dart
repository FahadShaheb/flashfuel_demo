import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final _productRef = FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProducts() async {
    final snapshot = await _productRef.get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }

  Future<void> addProduct(Product product) async {
    await _productRef.doc(product.id).set(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productRef.doc(id).delete();
  }
}
