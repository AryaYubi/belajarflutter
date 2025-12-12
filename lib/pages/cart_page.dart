// lib/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/cart_card.dart';
import 'package:shamo/services/cart_service.dart'; // Wajib diimpor

// [ASUMSI: CartCard, theme.dart, dan CartItemModel sudah ada dan diimpor dengan benar]

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
        // Tampilkan error jika ada
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
                      child: Text("Your cart is empty",
                          style: primaryTextStyle.copyWith(fontSize: 16)),
                    )
                  : ListView(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      children: cartItems
                          .map((item) => CartCard(
                                // Mengirim data ke CartCard
                                cartId: item['id'],
                                product: item['products'], 
                                quantity: item['qty'], // Menggunakan 'qty'
                                onUpdate: fetchCart, // Callback untuk refresh
                              ))
                          .toList(),
                    ),

      // FOOTER BAR
      bottomNavigationBar: cartItems.isEmpty
          ? const SizedBox() // Sembunyikan footer jika keranjang kosong
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
                    style:
                        priceTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
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
                onPressed: () => Navigator.pushNamed(context, '/checkout'),
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