import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product'),
      child: Container(
        margin: EdgeInsets.only(bottom: defaultMargin),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                product['img'],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                 errorBuilder: (ctx, _, __) => Image.asset('assets/image_shoes.png', width: 120, height: 120, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['cat'],
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product['name'],
                    style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product['price']}',
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