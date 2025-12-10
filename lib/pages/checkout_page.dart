import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/checkout_card.dart';
import 'package:shamo/widgets/custom_button.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        backgroundColor: bg1Color,
        elevation: 0,
        centerTitle: true,
        title: Text('Checkout Details', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          const SizedBox(height: 30),
          Text('List Items', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
          const CheckoutCard(),
          
          // Address Details
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: bg2Color, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(children: [
                      Image.asset('assets/icon_store_location.png', width: 40),
                      Image.asset('assets/icon_line.png', height: 30, errorBuilder: (_,__,___)=>Container(height:30, width:1, color:secondaryColor)),
                      Image.asset('assets/icon_your_address.png', width: 40),
                    ]),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Store Location', style: secondaryTextStyle.copyWith(fontSize: 12, fontWeight: light)),
                      Text('Adidas Core', style: primaryTextStyle.copyWith(fontWeight: medium)),
                      const SizedBox(height: 30),
                      Text('Your Address', style: secondaryTextStyle.copyWith(fontSize: 12, fontWeight: light)),
                      Text('Marsemoon', style: primaryTextStyle.copyWith(fontWeight: medium)),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          
          // Payment Summary
          Container(
            margin: EdgeInsets.only(top: defaultMargin),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: bg2Color, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Summary', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Product Quantity', style: secondaryTextStyle.copyWith(fontSize: 12)),
                  Text('2 Items', style: primaryTextStyle.copyWith(fontWeight: medium)),
                ]),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Product Price', style: secondaryTextStyle.copyWith(fontSize: 12)),
                  Text('\$575.96', style: primaryTextStyle.copyWith(fontWeight: medium)),
                ]),
                const SizedBox(height: 12),
                const Divider(thickness: 1, color: Color(0xff2E3141)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total', style: priceTextStyle.copyWith(fontSize: 14, fontWeight: semiBold)),
                  Text('\$575.92', style: priceTextStyle.copyWith(fontSize: 14, fontWeight: semiBold)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(text: 'Checkout Now', onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/checkout-success', (route) => false)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}