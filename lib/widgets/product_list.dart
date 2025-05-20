import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> _carouselImages = [
    'assets/images/slide1.jpg',
    'assets/images/slide2.jpg',
    'assets/images/slide3.jpg',
  ];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Mobil Diesel Special',
      'price': 550,
      'image': 'assets/images/image1.jpg',
    },
    {
      'name': 'Mobil Special',
      'price': 1000,
      'image': 'assets/images/image2.jpg',
    },
    {
      'name': 'Mobil Special 4T',
      'price': 800,
      'image': 'assets/images/image3.jpg',
    },
    {
      'name': 'Titan Gear Oil',
      'price': 560,
      'image': 'assets/images/image4.jpg',
    },
    {
      'name': 'Gulf Radiator Coolant',
      'price': 750,
      'image': 'assets/images/image5.jpg',
    },
    {
      'name': 'Shell Motor Oil',
      'price': 1100,
      'image': 'assets/images/image6.jpg',
    },
    {
      'name': 'Castrol Engine Oil',
      'price': 1050,
      'image': 'assets/images/image7.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flash Fuel")),
      body: Column(
        children: [
          // 🔁 Image Slider
          ImageSlideshow(
            width: double.infinity,
            height: 250,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            autoPlayInterval: 3000,
            isLoop: true,
            children:
                _carouselImages.map((path) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 16),

          // 🛒 Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            product['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "৳ ${product['price']}",
                              style: const TextStyle(color: Colors.green),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: SizedBox(
                                width: 100, // You can adjust width as needed
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6AC5FE),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: Add to cart logic
                                  },
                                  child: const Text(
                                    "Add to Cart",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
