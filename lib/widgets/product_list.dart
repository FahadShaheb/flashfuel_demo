import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref(
    'product/products',
  );
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _listenToCategories();
  }

  void _listenToCategories() {
    _productsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final Set<String> uniqueCategories = {};
        data.forEach((key, value) {
          final category = value['category'];
          if (category != null) {
            uniqueCategories.add(category.toString());
          }
        });
        setState(() {
          categories = uniqueCategories.toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Categories")),
      body:
          categories.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(categories[index]));
                },
              ),
    );
  }
}
