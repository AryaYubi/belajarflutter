import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';
import 'package:shamo/services/cart_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shamo/services/chat_service.dart';
import 'package:shamo/pages/detail_chat_page.dart';


class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int currentIndex = 0;
  bool isWishlist = false;
  int currentQuantity = 1;

  final supabase = Supabase.instance.client;

  // ───────────────────────────────────────────────
  // LOAD WISHLIST STATUS FROM SUPABASE
  // ───────────────────────────────────────────────
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkIfWishlist();
  }

  Future<void> _checkIfWishlist() async {
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final List data = await supabase
        .from('wishlists')
        .select()
        .eq('user_id', user.id)
        .eq('product_id', product['id']);

    if (mounted) setState(() => isWishlist = data.isNotEmpty);
  }

  // ───────────────────────────────────────────────
  // TOGGLE WISHLIST
  // ───────────────────────────────────────────────
  Future<void> _toggleWishlist() async {
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    if (isWishlist) {
      await supabase
          .from('wishlists')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', product['id']);

      if (mounted) setState(() => isWishlist = false);
    } else {
      await supabase.from('wishlists').insert({
        'user_id': user.id,
        'product_id': product['id'],
      });

      if (mounted) setState(() => isWishlist = true);
    }
  }

  // ───────────────────────────────────────────────
  // ADD TO CART (MERGED FROM VERSION 1)
  // ───────────────────────────────────────────────
  Future<void> handleAddToCart(int productId) async {
    try {
      await cartService.addToCart(productId, qty: currentQuantity);

      if (mounted) showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: alertColor,
          content:
              const Text("Failed to add to cart. Make sure you are logged in."),
        ),
      );
    }
  }

  Future<void> showSuccessDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bg3Color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

  // Indicator for image slider
  Widget indicator(int index) {
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
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int productId = product['id'];
    final String name = product['name'] ?? '';
    final String category = product['category'] ?? '';
    final String description =
        product['description'] ?? 'No description provided.';
    final dynamic price = product['price'] ?? 0;
    final String priceString = price.toStringAsFixed(2);
    final String imageUrl = product['image_url'] ?? '';

    final List<String> images = [imageUrl, imageUrl, imageUrl];

    return Scaffold(
      backgroundColor: const Color(0xffECEDEF),
      body: ListView(
        children: [
          // ───────────────────────────────────────────────
          // PRODUCT IMAGES
          // ───────────────────────────────────────────────
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
                    errorBuilder: (_, __, ___) =>
                        Image.asset('assets/image_shoes.png',
                            fit: BoxFit.cover),
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
                    const Icon(Icons.shopping_bag,
                        color: Colors.black, size: 28),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                images.asMap().entries.map((e) => indicator(e.key)).toList(),
          ),

          // ───────────────────────────────────────────────
          // PRODUCT DETAILS
          // ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 17),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              color: bg1Color,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME + CATEGORY + WISHLIST BUTTON
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
                      onTap: _toggleWishlist,
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

                // ───────────────────────────────────────────────
                // QUANTITY CONTROL
                // ───────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity',
                        style: primaryTextStyle.copyWith(fontWeight: medium)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: currentQuantity > 1
                              ? () => setState(() => currentQuantity--)
                              : null,
                          child: Icon(Icons.remove_circle_outline,
                              color: currentQuantity > 1
                                  ? primaryColor
                                  : secondaryTextColor),
                        ),
                        const SizedBox(width: 12),
                        Text(currentQuantity.toString(),
                            style: primaryTextStyle.copyWith(
                                fontSize: 16, fontWeight: medium)),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(() => currentQuantity++),
                          child: Icon(Icons.add_circle_outline,
                              color: primaryColor),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // DESCRIPTION
                Text('Description',
                    style: primaryTextStyle.copyWith(fontWeight: medium)),
                const SizedBox(height: 12),
                Text(description,
                    style: secondaryTextStyle.copyWith(fontWeight: light),
                    textAlign: TextAlign.justify),

                const SizedBox(height: 30),

               // CHAT + ADD TO CART
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
        onTap: () async {
          final sellerId = product['seller_id'];

          if (sellerId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Seller not found')),
            );
            return;
          }

          final chatId = await chatService.getOrCreateChat(
            sellerId: sellerId,
          );

          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailChatPage(chatId: chatId),
            ),
          );
        },
        child: Icon(Icons.chat,
            color: primaryColor, size: 28),
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: CustomButton(
        text: 'Add to Cart',
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