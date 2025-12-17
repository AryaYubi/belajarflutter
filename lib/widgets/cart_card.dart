import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/cart_service.dart';

class CartCard extends StatelessWidget {
  final int cartId;
  final Map<String, dynamic> product; // Data produk dari JOIN
  final int quantity;
  final VoidCallback onUpdate; // Untuk me-refresh keranjang

  const CartCard({
    super.key,
    required this.cartId,
    required this.product,
    required this.quantity,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = product['image_url'] ?? '';
    final String name = product['name'] ?? 'Unknown Product';
    final double price = (product['price'] ?? 0).toDouble();

    return Container(
      margin: EdgeInsets.only(top: defaultMargin),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bg2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stackTrace) {
                    print('ERROR LOADING CART IMAGE: $imageUrl');
                    return Image.asset(
                      'assets/image_shoes.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                    Text('\$${price.toStringAsFixed(2)}', style: priceTextStyle),
                  ],
                ),
              ),
              Column(
                children: [
                  // ADD button
                  GestureDetector(
                    onTap: () async {
                      await cartService.updateQuantity(cartId, quantity + 1);
                      onUpdate();
                    },
                    child: Icon(Icons.add_circle, color: primaryColor),
                  ),
                  const SizedBox(height: 2),
                  Text(quantity.toString(), style: primaryTextStyle.copyWith(fontWeight: medium)),
                  const SizedBox(height: 2),
                  // REDUCE button
                  GestureDetector(
                    onTap: () async {
                      if (quantity > 1) {
                        await cartService.updateQuantity(cartId, quantity - 1);
                      } else {
                        await cartService.removeItem(cartId);
                      }
                      onUpdate();
                    },
                    child: Icon(Icons.remove_circle, color: secondaryColor),
                  ),
                ],
              ),
            ],
          ),
          // REMOVE button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  await cartService.removeItem(cartId);
                  onUpdate();
                },
                child: Text('Remove', style: alertTextStyle.copyWith(fontSize: 12)),
              ),
            ],
          )
        ],
      ),
    );
  }
}