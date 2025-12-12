import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';
import 'package:shamo/services/cart_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int currentIndex = 0;
  bool isWishlist = false;

  final supabase = Supabase.instance.client;

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

    setState(() => isWishlist = data.isNotEmpty);
  }

  Future<void> _toggleWishlist() async {
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    if (isWishlist) {
      // Remove from wishlist
      await supabase
          .from('wishlists')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', product['id']);
      setState(() => isWishlist = false);
    } else {
      // Add to wishlist
      await supabase.from('wishlists').insert({
        'user_id': user.id,
        'product_id': product['id'],
      });
      setState(() => isWishlist = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String name = product['name'] ?? '';
    final String category = product['category'] ?? '';
    final String description =
        product['description'] ?? 'No description provided.';
    final dynamic price = product['price'] ?? 0;
    final String imageUrl = product['image_url'] ?? '';

    final List<String> images = [imageUrl, imageUrl, imageUrl];

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

    return Scaffold(
      backgroundColor: const Color(0xffECEDEF),
      body: ListView(
        children: [
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images
                .asMap()
                .entries
                .map((entry) => indicator(entry.key))
                .toList(),
          ),

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
                      Text('\$$price',
                          style: priceTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text('Description',
                    style: primaryTextStyle.copyWith(fontWeight: medium)),
                const SizedBox(height: 12),
                Text(description,
                    style: secondaryTextStyle.copyWith(fontWeight: light),
                    textAlign: TextAlign.justify),

                const SizedBox(height: 30),

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
                        onPressed: () async {
                          await cartService.addToCart(product['id']);
                          showSuccessDialog();
                        },
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