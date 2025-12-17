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
      appBar: AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'Checkout Success',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Cart icon.png',
              width: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'You made a transaction',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Stay at home while we\nprepare your dream shoes',
              style: secondaryTextStyle.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  CustomButton(
                    width: 200,
                    text: 'Order Other Shoes',
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/orders',
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: bg2Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View My Order',
                        textAlign: TextAlign.center,
                        style: secondaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
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