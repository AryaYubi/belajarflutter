import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/wishlist_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = fetchWishlistWithProduct();
  }

  Future<List<Map<String, dynamic>>> fetchWishlistWithProduct() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('wishlists')
        .select('id, created_at, products(*)')
        .eq('user_id', user.id);

    if (response == null) return [];

    final List<dynamic> data = response;

    return data.map<Map<String, dynamic>>((row) {
      final product = row['products'] ?? {};
      return {
        'wishlist_id': row['id'],
        'product_id': product['id'],
        'name': product['name'],
        'price': product['price'],
        'img': product['img'],
        'created_at': row['created_at'],
      };
    }).toList();
  }

  void _refreshWishlist() {
    setState(() {
      _wishlistFuture = fetchWishlistWithProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: bg1Color,
          centerTitle: true,
          title: Text(
            'Favorite Shoes',
            style: primaryTextStyle.copyWith(
              fontSize: 18,
              fontWeight: medium,
            ),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshWishlist,
            ),
          ],
        ),
        Expanded(
          child: Container(
            color: bg3Color,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _wishlistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  debugPrint('Wishlist fetch error: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Failed to load wishlist',
                      style: primaryTextStyle,
                    ),
                  );
                }

                final wishlistItems = snapshot.data ?? [];
                if (wishlistItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon_wishlist.png',
                          width: 74,
                          color: secondaryColor,
                        ),
                        const SizedBox(height: 23),
                        Text(
                          'You don\'t have dream shoes?',
                          style: primaryTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  children: wishlistItems
                      .map((item) => WishlistCard(item))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}