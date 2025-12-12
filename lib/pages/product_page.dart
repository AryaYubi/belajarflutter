// lib/pages/product_page.dart

import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';
import 'package:shamo/services/cart_service.dart'; 
// Diperlukan jika theme.dart tidak mendefinisikannya, namun baik untuk import
import 'package:supabase_flutter/supabase_flutter.dart'; 

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int currentIndex = 0;
  bool isWishlist = false;
  
  // STATE: Untuk melacak kuantitas yang dipilih
  int currentQuantity = 1; 

  // ======================================================
  // LOGIC ADD TO CART & WISHLIST
  // ======================================================

  Future<void> handleAddToCart(int productId) async {
    try {
        // Panggil service Add to Cart dengan kuantitas yang dipilih
        await cartService.addToCart(productId, qty: currentQuantity); 
        
        // Tampilkan dialog sukses jika berhasil
        if (mounted) {
          showSuccessDialog();
        }
    } catch (e) {
        // Tampilkan SnackBar jika error
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: alertColor, // Warna error dari theme
                    content: const Text("Gagal menambahkan ke keranjang. Pastikan Anda sudah login."),
                ),
            );
        }
    }
  }

  Future<void> showSuccessDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bg3Color, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: primaryTextColor),
                  ),
                ),
                Image.asset('assets/icon_success.png', width: 100),
                const SizedBox(height: 12),
                Text('Hurray :)',
                    style: primaryTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold)),
                const SizedBox(height: 12),
                Text('Item added successfully', style: secondaryTextStyle),
                const SizedBox(height: 20),
                CustomButton(
                    text: 'View My Cart',
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    width: 154),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget indicator(int index) {
    // Indikator PageView
    return Container(
      width: currentIndex == index ? 16 : 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: currentIndex == index ? primaryColor : const Color(0xffC4C4C4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ======================================================
    // RECEIVE PRODUCT DATA FROM HOMEPAGE
    // ======================================================
    final Map<String, dynamic> product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int productId = product['id'] as int;
    final String name = product['name'] ?? '';
    final String category = product['category'] ?? '';
    final String description = product['description'] ?? 'No description provided.';
    final String priceString = product['price']?.toStringAsFixed(2) ?? '0.00';
    final String imageUrl = product['image_url'] ?? '';

    final List<String> images = [imageUrl, imageUrl, imageUrl];


    return Scaffold(
      backgroundColor: const Color(0xffECEDEF), 
      body: ListView(
        children: [
          // ======================================================
          // IMAGE CAROUSEL
          // ======================================================
          Stack(
            children: [
              SizedBox(
                height: 350,
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (index) => setState(() => currentIndex = index),
                  itemBuilder: (context, index) => Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        Image.asset('assets/image_shoes.png', fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.chevron_left, size: 32)),
                    const Icon(Icons.shopping_bag, color: Colors.black, size: 28),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images
                .asMap()
                .entries
                .map((entry) => indicator(entry.key))
                .toList(),
          ),

          // ======================================================
          // PRODUCT INFO CONTENT
          // ======================================================
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 17),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              color: bg1Color, // Warna background konten
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME, CATEGORY, WISHLIST
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: primaryTextStyle.copyWith(
                                  fontSize: 18, fontWeight: semiBold)),
                          Text(category,
                              style:
                                  secondaryTextStyle.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => isWishlist = !isWishlist),
                      child: Image.asset(
                        isWishlist
                            ? 'assets/button_wishlist_blue.png'
                            : 'assets/button_wishlist.png',
                        width: 46,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PRICE BOX
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bg2Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text('Price starts from',
                          style: secondaryTextStyle.copyWith(fontSize: 12)),
                      const SizedBox(width: 6),
                      Text('\$$priceString',
                          style: priceTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                
                // === KONTROL KUANTITAS (QTY) ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity',
                        style: primaryTextStyle.copyWith(fontWeight: medium)),
                    Row(
                      children: [
                        // Tombol Minus
                        GestureDetector(
                          onTap: currentQuantity > 1
                              ? () => setState(() => currentQuantity--)
                              : null,
                          child: Icon(Icons.remove_circle_outline, 
                              // PERBAIKAN SINTAKSIS TERNARY
                              color: currentQuantity > 1 ? primaryColor : secondaryTextColor),
                        ),
                        const SizedBox(width: 12),
                        // Tampilan QTY
                        Text(
                          currentQuantity.toString(),
                          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
                        ),
                        const SizedBox(width: 12),
                        // Tombol Plus
                        GestureDetector(
                          onTap: () => setState(() => currentQuantity++),
                          child: Icon(Icons.add_circle_outline, color: primaryColor),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // === END KONTROL KUANTITAS (QTY) ===

                // DESCRIPTION
                Text('Description',
                    style:
                        primaryTextStyle.copyWith(fontWeight: medium)),
                const SizedBox(height: 12),
                Text(description,
                    style: secondaryTextStyle.copyWith(fontWeight: light),
                    textAlign: TextAlign.justify),

                const SizedBox(height: 30),

                // CHAT + ADD TO CART BUTTONS
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/detail-chat'),
                        child:
                            Icon(Icons.chat, color: primaryColor, size: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Add to Cart',
                        // Memanggil handleAddToCart dengan productId
                        onPressed: () => handleAddToCart(productId), 
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}