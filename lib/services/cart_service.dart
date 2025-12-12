// lib/services/cart_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart'; // Mengimport supabaseClient

// Asumsi: Jika Anda menggunakan model data, import di sini:
// import '../models/cart_item_model.dart'; 

class CartService {
  // Fungsi 1: Menambah/Update produk ke keranjang (dengan QTY)
  Future<void> addToCart(int productId, {int qty = 1}) async { 
    final uid = supabaseClient.auth.currentUser!.id; // Menggunakan supabaseClient

    final existing = await supabaseClient
        .from('carts')
        .select('id, qty') 
        .eq('user_id', uid) 
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      // UPDATE: Tambahkan kuantitas baru ke 'qty'
      final newQty = (existing['qty'] as int? ?? 1) + qty;
      await supabaseClient
          .from('carts')
          .update({'qty': newQty}) // Update kolom 'qty'
          .eq('id', existing['id']);
    } else {
      // INSERT: Masukkan kuantitas awal
      await supabaseClient.from('carts').insert({
        'user_id': uid,
        'product_id': productId,
        'qty': qty, // Insert kolom 'qty'
      });
    }
  }

  // Fungsi 2: Mengambil item keranjang untuk Cart/Checkout Page
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final uid = supabaseClient.auth.currentUser!.id;
    
    // Query untuk mengambil item, melakukan JOIN ke products (nama, harga, image)
    final response = await supabaseClient
        // PENTING: Menggunakan 'qty' (bukan 'quantity')
        .from('carts')
        .select('id, qty, products(id, name, price, image_url)') 
        .eq('user_id', uid);

    return List<Map<String, dynamic>>.from(response);
  }
}

final cartService = CartService();