// lib/models/product_model.dart

class ProductModel {
  final int id;
  final String name;
  final double price;
  final String? description;
  final String? category;
  final String? imageUrl;
  final List<ProductGalleryModel>? galleries;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.category,
    this.imageUrl,
    this.galleries,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<ProductGalleryModel>? galleriesList;
    
    if (json.containsKey('product_galleries') && json['product_galleries'] is List) {
      galleriesList = (json['product_galleries'] as List)
          .map((i) => ProductGalleryModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(), 
      description: json['description'] as String?,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      galleries: galleriesList,
    );
  }
}

class ProductGalleryModel {
  final int id;
  final int productId;
  final String imageUrl;

  ProductGalleryModel({
    required this.id,
    required this.productId,
    required this.imageUrl,
  });

  factory ProductGalleryModel.fromJson(Map<String, dynamic> json) {
    return ProductGalleryModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      imageUrl: json['image_url'] as String,
    );
  }
}