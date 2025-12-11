// import 'package:supabase_flutter/supabase_flutter.dart'; // [DIHAPUS]
import 'supabase_service.dart';

class CartService {
  Future<void> addToCart(int productId) async {
    final uid = supabase.auth.currentUser!.id;

    final existing = await supabase
        .from('carts')
        .select()
        .eq('user_id', uid)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      final newQty = (existing['quantity'] ?? 1) + 1;
      await supabase
          .from('carts')
          .update({'quantity': newQty})
          .eq('id', existing['id']);
    } else {
      await supabase.from('carts').insert({
        'user_id': uid,
        'product_id': productId,
        'quantity': 1,
      });
    }
  }
}

final cartService = CartService();