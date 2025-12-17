import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class ProductCard extends StatelessWidget {
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
          color: bg2Color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Image.asset('assets/image_shoes.png', width: 215, height: 150, fit: BoxFit.cover),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hiking', style: secondaryTextStyle.copyWith(fontSize: 12)),
                  const SizedBox(height: 6), 
                  // FIX: Hapus 'const' karena semiBold bukan constant
                      Text('COURT VISION 2.0',
                        style: primaryTextStyle.copyWith(
                          color: primaryTextColor, fontSize: 18, fontWeight: semiBold),
                        overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6), 
                  Text('\$58,67', style: priceTextStyle.copyWith(fontSize: 14, fontWeight: medium)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}