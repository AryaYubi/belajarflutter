// lib/widgets/wishlist_card.dart
import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const WishlistCard(this.product, {super.key});

  @override
  State<WishlistCard> createState() => _WishlistCardState();
}

class _WishlistCardState extends State<WishlistCard> {
  final supabase = Supabase.instance.client;
  bool isWishlist = true; // Always true when loaded from wishlist

  Future<void> _removeFromWishlist() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
          .from('wishlists')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', widget.product['product_id']);

      setState(() => isWishlist = false);

      // Show red notification
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from wishlist'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove: $e'),
            backgroundColor: alertColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.product['name'] ?? 'Unknown';
    final dynamic price = widget.product['price'] ?? 0;
    final String? imgUrl = widget.product['img'];

    if (!isWishlist) {
      // Return empty container if removed from wishlist
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 10, left: 12, bottom: 14, right: 20),
      decoration: BoxDecoration(
        color: bg2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imgUrl != null && imgUrl.isNotEmpty
                ? Image.network(
                    imgUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, stackTrace) =>
                        Image.asset('assets/image_shoes.png', width: 60, height: 60, fit: BoxFit.cover),
                  )
                : Image.asset('assets/image_shoes.png', width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$$price',
                  style: priceTextStyle,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _removeFromWishlist,
            child: Image.asset(
              'assets/button_wishlist_blue.png',
              width: 34,
            ),
          ),
        ],
      ),
    );
  }
}