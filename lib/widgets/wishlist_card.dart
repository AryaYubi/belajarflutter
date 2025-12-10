import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class WishlistCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const WishlistCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 10, left: 12, bottom: 14, right: 20),
      decoration: BoxDecoration(
        color: bg2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product['img'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => Image.asset('assets/image_shoes.png', width: 60, height: 60, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
                ),
                Text(
                  '\$${product['price']}',
                  style: priceTextStyle,
                ),
              ],
            ),
          ),
          Image.asset('assets/button_wishlist_blue.png', width: 34),
        ],
      ),
    );
  }
}