import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:shamo/services/supabase_service.dart'; // [DIHAPUS]

class CartCard extends StatelessWidget {
  final int cartId;
  final Map<String, dynamic> product;
  final int quantity;
  final VoidCallback onUpdate;

  const CartCard({
    super.key,
    required this.cartId,
    required this.product,
    required this.quantity,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    Future<void> increaseQty() async {
      await supabase
          .from('carts')
          .update({'quantity': quantity + 1})
          .eq('id', cartId);
      onUpdate();
    }

    Future<void> decreaseQty() async {
      if (quantity == 1) {
        // delete item
        await supabase.from('carts').delete().eq('id', cartId);
      } else {
        await supabase
            .from('carts')
            .update({'quantity': quantity - 1})
            .eq('id', cartId);
      }
      onUpdate();
    }

    Future<void> deleteItem() async {
      await supabase.from('carts').delete().eq('id', cartId);
      onUpdate();
    }

    return Container(
      margin: EdgeInsets.only(top: defaultMargin),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bg2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // --------------------------------------------------
          // PRODUCT ROW
          // --------------------------------------------------
          Row(
            children: [
              // IMAGE
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: product['image_url'] != null
                        ? NetworkImage(product['image_url'])
                        : const AssetImage('assets/image_shoes.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // NAME & PRICE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? '',
                      style: primaryTextStyle.copyWith(fontWeight: semiBold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${product['price'].toString()}',
                      style: priceTextStyle,
                    ),
                  ],
                ),
              ),

              // QTY BUTTONS
              Column(
                children: [
                  GestureDetector(
                    onTap: increaseQty,
                    child: Image.asset('assets/button_add.png', width: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    quantity.toString(),
                    style:
                        primaryTextStyle.copyWith(fontWeight: medium),
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: decreaseQty,
                    child: Image.asset('assets/button_min.png', width: 16),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // --------------------------------------------------
          // REMOVE
          // --------------------------------------------------
          GestureDetector(
            onTap: deleteItem,
            child: Row(
              children: [
                const Icon(Icons.delete, color: Color(0xffED6363), size: 14),
                const SizedBox(width: 4),
                Text(
                  'Remove',
                  style: primaryTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: light,
                    color: const Color(0xffED6363),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}