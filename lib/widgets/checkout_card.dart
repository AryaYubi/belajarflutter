// lib/widgets/checkout_card.dart

import 'package:flutter/material.dart';
import 'package:shamo/theme.dart'; // Asumsi theme.dart ada

class CheckoutCard extends StatelessWidget {
  // DEKLARASI PARAMETER YANG HILANG
  final String name;
  final String imageUrl;
  final double price;
  final int qty;

  const CheckoutCard({
    super.key,
    // WAJIB: Definisikan parameter bernama yang dibutuhkan
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    // Harga item individu
    final double itemTotal = price * qty;
    
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bg2Color, // Warna latar belakang kartu
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 1. Gambar Produk
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stackTrace) => 
                Image.asset('assets/image_shoes.png', width: 60, height: 60, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),

          // 2. Detail Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: priceTextStyle,
                ),
              ],
            ),
          ),

          // 3. Kuantitas dan Harga Total Item
          Column(
            children: [
              Text(
                '${qty} Items', // Menampilkan kuantitas
                style: secondaryTextStyle.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '${itemTotal.toStringAsFixed(2)}', 
                style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}