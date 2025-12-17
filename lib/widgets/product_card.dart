import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product'),
      child: Container(
        width: 215,
        height: 278,
        margin: EdgeInsets.only(right: defaultMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
            color: bg2Color, // use theme bg2Color for card background
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Menggunakan NetworkImage sesuai data original, tapi bisa diganti Image.asset jika mau static
            Image.network(
              product['img'],
              width: 215,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => Image.asset('assets/image_shoes.png', width: 215, height: 150, fit: BoxFit.cover),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['cat'],
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 6),

                  // NAME
                      Text('COURT VISION 2.0',
                        style: primaryTextStyle.copyWith(
                          color: primaryTextColor, fontSize: 18, fontWeight: semiBold),
                        overflow: TextOverflow.ellipsis),

                  const SizedBox(height: 6),
                  Text(
                    '\$${product['price']}',
                    style: priceTextStyle.copyWith(fontSize: 14, fontWeight: medium),
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