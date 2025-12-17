// lib/models/cart_item_model.dart
class CartItemModel {
  final int id; // Cart ID (dari tabel carts)
  final int productId;
  final String productName;
  final double price;
  int qty;
  
  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.qty,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Asumsi: Kita melakukan join untuk mendapatkan nama produk dan harga
    return CartItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      // Asumsi: Struktur response Supabase untuk cart join product
      productName: json['products']['name'] as String,
      price: (json['products']['price'] as num).toDouble(), 
      qty: json['qty'] as int,
    );
  }
}