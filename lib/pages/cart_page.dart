// lib/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/cart_card.dart';
import 'package:shamo/services/cart_service.dart'; // Wajib diimpor

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> cartItems = [];
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  // Fetch data cart dari Supabase
  Future<void> fetchCart() async {
    try {
      final res = await cartService.getCartItems(); // Menggunakan Service

      // Sort cart items by id to keep stable order
      res.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

      // Hitung subtotal
      double total = 0;
      for (var item in res) {
        final price = (item['products']['price'] ?? 0).toDouble();
        final qty = item['qty'] as int? ?? 1; // Menggunakan kolom 'qty'
        total += price * qty;
      }

      if (!mounted) return;

      setState(() {
        cartItems = res;
        subtotal = total;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print('Error loading cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'assets/button_back.png', 
            width: 8,
          ),
        ),
        title: Text(
          'Your Cart',
          style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium),
        ),
        elevation: 0,
      ),

      // BODY
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon_empty_cart.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Opss! Your Cart is Empty',
                        style: primaryTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Let's find your favorite shoes",
                        style: secondaryTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/home'),
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Explore Store',
                            style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  children: cartItems
                      .map((item) => CartCard(
                            cartId: item['id'],
                            product: item['products'],
                            quantity: item['qty'],
                            onUpdate: fetchCart, // Callback untuk refresh
                          ))
                      .toList(),
                ),

      // FOOTER BAR
      bottomNavigationBar: cartItems.isEmpty
          ? const SizedBox()
          : SizedBox(
              height: 180,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: primaryTextStyle),
                        Text(
                          '\$${subtotal.toStringAsFixed(2)}',
                          style: priceTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold),
                        ),
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
                      onPressed: () =>
                          Navigator.pushNamed(context, '/checkout'),
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Continue to Checkout',
                              style: primaryTextStyle.copyWith(
                                  fontSize: 16, fontWeight: semiBold)),
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