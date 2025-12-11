import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/cart_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shamo/services/supabase_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final supabase = Supabase.instance.client;

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
    final userId = supabase.auth.currentUser!.id;

    final res = await supabase
        .from('carts')
        .select('id, quantity, products(*)')
        .eq('user_id', userId);

    List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(res);

    // Hitung subtotal
    double total = 0;
    for (var item in items) {
      final price = (item['products']['price'] ?? 0).toDouble();
      final qty = item['quantity'] ?? 1;
      total += price * qty;
    }

    setState(() {
      cartItems = items;
      subtotal = total;
      isLoading = false;
    });
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
                            cartId: item['id'],
                            product: item['products'],
                            quantity: item['quantity'],
                            onUpdate: fetchCart,
                          ))
                      .toList(),
                ),

      // FOOTER BAR
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
