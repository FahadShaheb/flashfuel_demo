import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

// class ProductService {
//   final _productRef = FirebaseFirestore.instance.collection('products');

//   Future<List<Product>> fetchProducts() async {
//     final snapshot = await _productRef.get();
//     return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
//   }

//   Future<void> addProduct(Product product) async {
//     await _productRef.doc(product.id).set(product.toMap());
//   }

//   Future<void> deleteProduct(String id) async {
//     await _productRef.doc(id).delete();
//   }
// }

class FirebaseService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');

  // Create a new product
  Future<void> addProduct(Product product) async {
    try {
      await productsCollection.add({
        'category': product.category,
        'imageUrl': product.imageUrl,
        'name': product.name,
        'price': product.price,
      });
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  // Get all products
  Stream<List<Product>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get a single product by ID
  Future<Product> getProductById(String id) async {
    try {
      DocumentSnapshot doc = await productsCollection.doc(id).get();
      return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error getting product: $e');
      rethrow;
    }
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      await productsCollection.doc(product.id).update({
        'category': product.category,
        'imageUrl': product.imageUrl,
        'name': product.name,
        'price': product.price,
      });
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      await productsCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}
