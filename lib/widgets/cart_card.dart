import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class CartCard extends StatelessWidget {
  const CartCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/image_shoes.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Terrex Urban Low', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                    Text('\$143,98', style: priceTextStyle),
                  ],
                ),
              ),
              Column(
                children: [
                  Image.asset('assets/button_add.png', width: 16),
                  const SizedBox(height: 2),
                  Text('2', style: primaryTextStyle.copyWith(fontWeight: medium)),
                  const SizedBox(height: 2),
                  Image.asset('assets/button_min.png', width: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.delete, color: Color(0xffED6363), size: 14),
              const SizedBox(width: 4),
              Text('Remove', style: primaryTextStyle.copyWith(fontSize: 12, fontWeight: light, color: const Color(0xffED6363))),
            ],
          ),
        ],
      ),
    );
  }
}