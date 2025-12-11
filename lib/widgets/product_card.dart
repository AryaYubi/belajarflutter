import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data Supabase dengan key yang benar
    final String imageUrl = product['image_url'] ?? '';
    final String category = product['category'] ?? 'Unknown';
    final String name = product['name'] ?? '';
    final dynamic price = product['price'] ?? 0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product', arguments: product),
      child: Container(
        width: 215,
        height: 278,
        margin: EdgeInsets.only(right: defaultMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffECEDEF),
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
                errorBuilder: (ctx, _, __) => Image.asset(
                  'assets/image_shoes.png',
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
                      color: const Color(0xff2E2E2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // PRICE
                  Text(
                    '\$${price.toString()}',
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
