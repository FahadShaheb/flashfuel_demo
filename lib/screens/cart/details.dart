import 'package:flash_fuel/models/product.dart';
import 'package:flash_fuel/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  late String _productId;
  bool _isLoading = true;
  Product? _product;
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
        _product = product;
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
      appBar: AppBar(
        title: Text(_isLoading ? 'Product Details' : _product!.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/edit',
                arguments: _productId,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_product!.imageUrl.isNotEmpty)
                      Center(
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _product!.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(child: Icon(Icons.image, size: 64)),
                        ),
                      ),

                    SizedBox(height: 24),

                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 8),
                            DetailRow(label: 'ID', value: _product!.id),
                            DetailRow(label: 'Name', value: _product!.name),
                            DetailRow(
                              label: 'Category',
                              value: _product!.category,
                            ),
                            DetailRow(
                              label: 'Price',
                              value: '\$${_product!.price.toString()}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Product'),
            content: Text('Are you sure you want to delete ${_product!.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog

                  await _firebaseService.deleteProduct(_product!.id);

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Product deleted')));

                  Navigator.pop(context); // Go back to home screen
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
