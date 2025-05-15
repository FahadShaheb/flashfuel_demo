// File: lib/screens/edit_product_screen.dart
import 'package:flash_fuel/models/product.dart';
import 'package:flash_fuel/services/product_service.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  late String _productId;
  String _category = '';
  String _imageUrl = '';
  String _name = '';
  double _price = 0.0;
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _productId = ModalRoute.of(context)!.settings.arguments as String;
      _loadProduct();
      _isInitialized = true;
    }
  }

  Future<void> _loadProduct() async {
    try {
      final product = await _firebaseService.getProductById(_productId);

      setState(() {
        _name = product.name;
        _category = product.category;
        _imageUrl = product.imageUrl;
        _price = product.price;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading product: $e')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: _category,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _category = value!;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: _imageUrl,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _imageUrl = value ?? '';
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: _price.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _updateProduct,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Update Product',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        final updatedProduct = Product(
          id: _productId,
          name: _name,
          category: _category,
          imageUrl: _imageUrl,
          price: _price,
        );

        await _firebaseService.updateProduct(updatedProduct);

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Product updated successfully')));

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating product: $e')));
      }
    }
  }
}
