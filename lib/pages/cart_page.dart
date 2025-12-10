import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/cart_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text('Your Cart', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: const [
          CartCard(),
          CartCard(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 180,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: primaryTextStyle),
                  Text('\$287,96', style: priceTextStyle.copyWith(fontSize: 16, fontWeight: semiBold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Divider(thickness: 0.3, color: subtitleTextColor),
            const SizedBox(height: 30),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/checkout'),
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Continue to Checkout', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: semiBold)),
                    Icon(Icons.arrow_forward, color: primaryTextColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}