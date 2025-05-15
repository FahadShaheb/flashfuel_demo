import 'package:flash_fuel/models/product.dart';
import 'package:flash_fuel/services/product_service.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  String _category = '';
  String _imageUrl = '';
  String _name = '';
  double _price = 0.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
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
                        onPressed: _saveProduct,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Save Product',
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

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // Generate temporary ID since actual ID will be assigned by Firebase
        final newProduct = Product(
          id: 'temp-id',
          name: _name,
          category: _category,
          imageUrl: _imageUrl,
          price: _price,
        );

        await _firebaseService.addProduct(newProduct);

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Product added successfully')));

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding product: $e')));
      }
    }
  }
}
