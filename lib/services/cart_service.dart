import 'supabase_service.dart';

class CartService {
  // Add or update quantity
  Future<void> addToCart(int productId, {int qty = 1}) async {
    final uid = supabaseClient.auth.currentUser!.id;

    final existing = await supabaseClient
        .from('carts')
        .select('id, qty')
        .eq('user_id', uid)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      final newQty = (existing['qty'] as int? ?? 1) + qty;
      await supabaseClient
          .from('carts')
          .update({'qty': newQty})
          .eq('id', existing['id']);
    } else {
      await supabaseClient.from('carts').insert({
        'user_id': uid,
        'product_id': productId,
        'qty': qty,
      });
    }
  }

  // Fetch cart items
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final uid = supabaseClient.auth.currentUser!.id;

    final response = await supabaseClient
        .from('carts')
        .select('id, qty, products(id, name, price, image_url)')
        .eq('user_id', uid);

    return List<Map<String, dynamic>>.from(response);
  }

  // New: Update quantity directly
  Future<void> updateQuantity(int cartId, int qty) async {
    await supabaseClient
        .from('carts')
        .update({'qty': qty})
        .eq('id', cartId);
  }

  // New: Remove item from cart
  Future<void> removeItem(int cartId) async {
    await supabaseClient
        .from('carts')
        .delete()
        .eq('id', cartId);
  }
}

final cartService = CartService();