// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
// import 'package:shamo/pages/product_page.dart'; // Tidak perlu jika menggunakan Named Route '/product'

class ProductCard extends StatelessWidget {
  // Menerima data produk sebagai Map<String, dynamic> dari Supabase Stream
  final Map<String, dynamic> product;

  const ProductCard(this.product, {super.key}); 

  @override
  Widget build(BuildContext context) {
    // Ambil data Supabase dengan key yang benar
    final String imageUrl = product['image_url'] ?? '';
    final String category = product['category'] ?? 'Unknown';
    final String name = product['name'] ?? '';
    // Konversi dynamic/numeric dari DB ke String/double untuk tampilan
    final String priceString = product['price']?.toStringAsFixed(2) ?? '0.00';

    return GestureDetector(
      // Navigasi ke halaman detail produk (/product) dan kirim data produk
      onTap: () => Navigator.pushNamed(context, '/product', arguments: product),
      child: Container(
        width: 215,
        height: 278,
        margin: EdgeInsets.only(right: defaultMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffECEDEF), // Warna latar belakang kartu
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // =============================
            // IMAGE
            // =============================
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: 215,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) => Image.asset(
                  'assets/image_shoes.png', // Fallback image
                  width: 215,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // =============================
            // PRODUCT INFO
            // =============================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY
                  Text(
                    category,
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  // NAME
                  Text(
                    name,
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                      color: const Color(0xff2E2E2E), // Warna teks nama
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // PRICE
                  Text(
                    '\$$priceString',
                    style: priceTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}