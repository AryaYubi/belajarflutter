import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  bool isProcessing = false;
  List<Map<String, dynamic>> cartItems = [];
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final res = await supabase
          .from('carts')
          .select('id, quantity, products(*)')
          .eq('user_id', userId);

      List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(res);

      double total = 0;
      for (var item in items) {
        final price = (item['products']['price'] ?? 0).toDouble();
        final qty = item['quantity'] ?? 1;
        total += price * qty;
      }

      if (!mounted) return;

      setState(() {
        cartItems = items;
        subtotal = total;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> processCheckout() async {
    if (cartItems.isEmpty) return;

    setState(() => isProcessing = true);

    try {
      final userId = supabase.auth.currentUser!.id;

      // Create order
      final orderRes = await supabase
          .from('orders')
          .insert({
            'user_id': userId,
            'total_amount': subtotal,
            'status': 'pending',
          })
          .select()
          .single();

      final orderId = orderRes['id'];

      // Create order items
      for (var cartItem in cartItems) {
        await supabase.from('order_items').insert({
          'order_id': orderId,
          'product_id': cartItem['products']['id'],
          'quantity': cartItem['quantity'],
          'price': cartItem['products']['price'],
        });
      }

      // Clear cart
      await supabase.from('carts').delete().eq('user_id', userId);

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/checkout-success',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
      
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: bg3Color,
        appBar: AppBar(
          backgroundColor: bg1Color,
          elevation: 0,
          centerTitle: true,
          title: Text('Checkout Details', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final itemCount = cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

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
          
          // Cart Items
          ...cartItems.map((item) {
            final product = item['products'];
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(product['image_url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: primaryTextStyle.copyWith(fontWeight: semiBold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '\$${product['price']}',
                          style: priceTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item['quantity']} Items',
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
          
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
                      Image.asset('assets/icon_line.png', height: 30, errorBuilder: (context, error, stackTrace) => Container(height: 30, width: 1, color: secondaryColor)),
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
                  Text('$itemCount Items', style: primaryTextStyle.copyWith(fontWeight: medium)),
                ]),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Product Price', style: secondaryTextStyle.copyWith(fontSize: 12)),
                  Text('\$${subtotal.toStringAsFixed(2)}', style: primaryTextStyle.copyWith(fontWeight: medium)),
                ]),
                const SizedBox(height: 12),
                const Divider(thickness: 1, color: Color(0xff2E3141)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total', style: priceTextStyle.copyWith(fontSize: 14, fontWeight: semiBold)),
                  Text('\$${subtotal.toStringAsFixed(2)}', style: priceTextStyle.copyWith(fontSize: 14, fontWeight: semiBold)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: isProcessing ? 'Processing...' : 'Checkout Now',
            onPressed: isProcessing ? () {} : processCheckout,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}