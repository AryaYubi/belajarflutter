// lib/pages/checkout_success_page.dart
import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';

class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg3Color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon_empty_cart.png', width: 80, color: secondaryColor), // Gunakan cart icon jika tidak ada icon spesifik
            const SizedBox(height: 20),
            Text('You made a transaction', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
            const SizedBox(height: 12),
            Text('Stay at home while we\nprepare your dream shoes', style: secondaryTextStyle, textAlign: TextAlign.center),
            const SizedBox(height: 30),
            CustomButton(width: 196, text: 'Order Other Shoes', onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false)),
          ],
        ),
      ),
    );
  }
}