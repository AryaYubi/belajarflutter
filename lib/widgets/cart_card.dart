// lib/widgets/cart_card.dart (ASUMSI UPDATE)

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
    // 1. Akses URL Gambar dari Map 'product'
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
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl, // GUNAKAN URL YANG DI-FETCH
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  // Tambahkan errorBuilder untuk melihat apakah URL bermasalah
                  errorBuilder: (ctx, error, stackTrace) {
                    print('ERROR LOADING CART IMAGE: $imageUrl');
                    return Image.asset('assets/image_shoes.png', 
                        width: 60, 
                        height: 60, 
                        fit: BoxFit.cover); // Fallback Image
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Detail Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                    Text('\$${price.toStringAsFixed(2)}', style: priceTextStyle),
                  ],
                ),
              ),

              // Kontrol Kuantitas
              Column(
                children: [
                  // Tombol Plus (Anda mungkin memiliki logika update cart di sini)
                  GestureDetector(
                    onTap: () {
                      // Logic: cartService.addToCart(product['id'], qty: 1)
                      // Panggil onUpdate() setelah berhasil
                    },
                    child: Icon(Icons.add_circle, color: primaryColor),
                  ),
                  const SizedBox(height: 2),
                  Text(quantity.toString(), style: primaryTextStyle.copyWith(fontWeight: medium)),
                  const SizedBox(height: 2),
                  // Tombol Minus (Anda mungkin memiliki logika update cart di sini)
                  GestureDetector(
                    onTap: () {
                      // Logic: cartService.removeFromCart(product['id'])
                      // Panggil onUpdate() setelah berhasil
                    },
                    child: Icon(Icons.remove_circle, color: secondaryColor),
                  ),
                ],
              ),
            ],
          ),
          
          // Tombol Remove (Sesuai Figma/UI lama)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                    // Logic: Hapus item dari keranjang (cartId)
                    // Panggil onUpdate() setelah berhasil
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