// lib/services/product_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import 'supabase_service.dart'; // Mengandung 'supabaseClient'

class ProductService {
  // SOLUSI: Mengganti SupabaseService.client dengan supabaseClient
  final SupabaseClient _supabaseClient = supabaseClient; 

  Future<ProductModel> getProductDetail(int productId) async {
    try {
      // Mengambil detail produk DENGAN GALERI
      final response = await _supabaseClient
          .from('products')
          .select('*, product_galleries(*)') 
          .eq('id', productId)
          .single(); 

      return ProductModel.fromJson(response);
    } catch (e) {
      print('Error fetching product detail: $e'); 
      rethrow; 
    }
  }

  // Tambahkan fungsi lain untuk mengambil daftar produk
  Future<List<ProductModel>> getProducts() async {
      try {
        final List<Map<String, dynamic>> response = await _supabaseClient
            .from('products')
            .select('*');

        return response.map((data) => ProductModel.fromJson(data)).toList();
      } catch (e) {
          print('Error fetching products: $e');
          return [];
      }
  }
}