// lib/pages/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/checkout_card.dart';
import 'package:shamo/widgets/custom_button.dart';
import 'package:shamo/services/cart_service.dart'; 
import 'package:shamo/services/profile_service.dart'; 
// import 'package:shamo/models/profile_model.dart'; // Import model profile jika ada

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _cartItems = [];
  Map<String, dynamic>? _userProfile;
  
  // Asumsi biaya kirim tetap
  final double _shippingCost = 10.00; 

  @override
  void initState() {
    super.initState();
    _fetchCheckoutData();
  }

  // Fetch data Cart dan Profile secara Bersamaan (Concurrent Fetching)
  Future<void> _fetchCheckoutData() async {
    try {
      // 1. Definisikan dua Future
      final cartFuture = cartService.getCartItems(); 
      final profileFuture = profileService.getProfile(); 

      // 2. Tunggu kedua Future selesai secara bersamaan
      final results = await Future.wait([cartFuture, profileFuture]);

      if (!mounted) return;

      setState(() {
        _cartItems = results[0] as List<Map<String, dynamic>>;
        _userProfile = results[1] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      print('Error fetching checkout data: $e');
      setState(() {
        _isLoading = false;
      });
      // Opsional: tampilkan error ke pengguna
    }
  }

  // === FUNGSI PERHITUNGAN DINAMIS ===
  
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
        final int qty = item['qty'] as int? ?? 0;
        total += qty;
      }
      return total;
  }

  double get _finalTotal => _subtotal + _shippingCost;
  
  // === END FUNGSI PERHITUNGAN DINAMIS ===

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: bg3Color,
        appBar: AppBar(title: Text('Checkout Details', style: primaryTextStyle)),
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }
    
    if (_cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: bg3Color,
        appBar: AppBar(title: Text('Checkout Details', style: primaryTextStyle)),
        body: Center(child: Text('Keranjang Anda kosong saat checkout.', style: secondaryTextStyle)),
      );
    }

    // Ambil data alamat dari profile
    final String address = _userProfile?['address'] ?? 'Set Your Address';
    // Asumsi Anda juga menyimpan full address di tabel profiles

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
          
          // List item keranjang (dinamis)
          Column(
            children: _cartItems.map((item) => CheckoutCard(
                // Mengirim data ke CheckoutCard
                name: item['products']['name'],
                imageUrl: item['products']['image_url'],
                price: (item['products']['price'] ?? 0).toDouble(),
                qty: item['qty'] as int,
            )).toList(),
          ),

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
                      Container(height: 30, width: 1, color: secondaryColor), 
                      Image.asset('assets/icon_your_address.png', width: 40),
                    ]),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Store Location', style: secondaryTextStyle.copyWith(fontSize: 12, fontWeight: light)),
                      Text('Adidas Core', style: primaryTextStyle.copyWith(fontWeight: medium)),
                      const SizedBox(height: 30),
                      Text('Your Address', style: secondaryTextStyle.copyWith(fontSize: 12, fontWeight: light)),
                      // Data Alamat Dinamis
                      Text(address, style: primaryTextStyle.copyWith(fontWeight: medium)), 
                    ]),
                  ],
                ),
              ],
            ),
          ),
          
          // Payment Summary (Dinamis)
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
                  // Data Dinamis
                  Text('${_totalQuantity} Items', style: primaryTextStyle.copyWith(fontWeight: medium)), 
                ]),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Product Price (Subtotal)', style: secondaryTextStyle.copyWith(fontSize: 12)),
                  // Data Dinamis
                  Text('\$${_subtotal.toStringAsFixed(2)}', style: primaryTextStyle.copyWith(fontWeight: medium)), 
                ]),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Shipping', style: secondaryTextStyle.copyWith(fontSize: 12)),
                  Text('\$${_shippingCost.toStringAsFixed(2)}', style: primaryTextStyle.copyWith(fontWeight: medium)), 
                ]),
                const Divider(thickness: 1, color: Color(0xff2E3141)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total', style: priceTextStyle.copyWith(fontSize: 14, fontWeight: semiBold)),
                  // Data Dinamis
                  Text('\$${_finalTotal.toStringAsFixed(2)}', style: priceTextStyle.copyWith(fontSize: 14, fontWeight: semiBold)), 
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