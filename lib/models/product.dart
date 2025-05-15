class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }
}
