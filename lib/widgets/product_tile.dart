import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari Supabase
    final String imageUrl = product['image_url'] ?? '';
    final String category = product['category'] ?? 'Unknown';
    final String name = product['name'] ?? '';
    final dynamic price = product['price'] ?? 0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/product',
        arguments: product, // kirim data ke detail page
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: defaultMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                // Perbaikan: Mengganti __ menjadi _
                errorBuilder: (ctx, error, stackTrace) => Image.asset(
                  'assets/image_shoes.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // PRODUCT INFO
            Expanded(
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
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // PRICE
                  Text(
                    '\$${price.toString()}',
                    style: priceTextStyle.copyWith(fontWeight: medium),
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