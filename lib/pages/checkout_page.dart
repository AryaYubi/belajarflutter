import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/checkout_card.dart';
import 'package:shamo/widgets/custom_button.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
<<<<<<< Updated upstream
=======
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isLoading = true;
  bool _isProcessing = false; // Untuk checkout button
  List<Map<String, dynamic>> _cartItems = [];
  Map<String, dynamic>? _userProfile;

  final double _shippingCost = 10.0;

  @override
  void initState() {
    super.initState();
    _fetchCheckoutData();
  }

  Future<void> _fetchCheckoutData() async {
    try {
      final cartFuture = cartService.getCartItems();
      final profileFuture = profileService.getProfile();

      final results = await Future.wait([cartFuture, profileFuture]);

      if (!mounted) return;

      // Sort cart items by id
      final List<Map<String, dynamic>> sortedCart =
          (results[0] as List<Map<String, dynamic>>)
            ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

      setState(() {
        _cartItems = sortedCart;
        _userProfile = results[1] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      print('Error fetching checkout data: $e');
      setState(() => _isLoading = false);
    }
  }

  double get _subtotal {
    double total = 0.0;
    for (var item in _cartItems) {
      final double price = (item['products']['price'] ?? 0).toDouble();
      final int qty = item['qty'] as int? ?? 0;
      total += price * qty;
    }
    return total;
  }

  int get _totalQuantity {
    int total = 0;
    for (var item in _cartItems) {
      total += item['qty'] as int? ?? 0;
    }
    return total;
  }

  double get _finalTotal => _subtotal + _shippingCost;

  // Fungsi checkout
  Future<void> _checkout() async {
    if (_cartItems.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final uid = supabaseClient.auth.currentUser!.id;

      // 1. Insert into transactions
      final transactionRes = await supabaseClient
          .from('transactions')
          .insert({
            'user_id': uid,
            'total_price': _finalTotal,
          })
          .select()
          .maybeSingle();

      if (transactionRes == null) throw 'Failed to create transaction';

      final transactionId = transactionRes['id'];

      // 2. Insert into transaction_items
      final List<Map<String, dynamic>> itemsToInsert = _cartItems.map((item) {
        final double price = (item['products']['price'] ?? 0).toDouble();
        final int qty = item['qty'] as int? ?? 1;
        return {
          'transaction_id': transactionId,
          'product_id': item['products']['id'],
          'product_name': item['products']['name'],
          'product_price': price,
          'quantity': qty,
          'total_price': price * qty,
        };
      }).toList();

      await supabaseClient.from('transaction_items').insert(itemsToInsert);

      // 3. Clear cart
      for (var item in _cartItems) {
        await supabaseClient
            .from('carts')
            .delete()
            .eq('id', item['id']);
      }

      if (!mounted) return;

      // 4. Navigate to checkout success
      Navigator.pushNamedAndRemoveUntil(
          context, '/checkout-success', (route) => false);
    } catch (e) {
      print('Checkout failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checkout failed. Try again.'),
          backgroundColor: alertColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                const Divider(thickness: 1, color: Color(0xff2E3141)),
=======
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping', style: secondaryTextStyle.copyWith(fontSize: 12)),
                      Text('\$${_shippingCost.toStringAsFixed(2)}',
                          style: primaryTextStyle.copyWith(fontWeight: medium)),
                    ]),
                Divider(thickness: 1, color: subtitleTextColor),
>>>>>>> Stashed changes
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