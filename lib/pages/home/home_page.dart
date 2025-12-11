import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/product_card.dart';
import 'package:shamo/widgets/product_tile.dart';
import 'package:shamo/services/profile_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  // ============================
  // USER PROFILE
  // ============================
  Map<String, dynamic>? profile;
  bool loadingProfile = true;

  Future<void> fetchProfile() async {
    try {
      final res = await profileService.getProfile();
      setState(() {
        profile = res;
        loadingProfile = false;
      });
    } catch (e) {
      print("ERROR FETCH PROFILE: $e");
      setState(() => loadingProfile = false);
    }
  }

  // ============================
  // PRODUCTS
  // ============================
  String selectedCategory = 'All Shoes';
  bool loadingProduct = true;
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final res = await supabase.from('products').select();

      setState(() {
        products = List<Map<String, dynamic>>.from(res);
        loadingProduct = false;
      });
    } catch (e) {
      print("ERROR LOADING PRODUCTS: $e");
      setState(() => loadingProduct = false);
    }
  }

  // ============================
  // INIT
  // ============================
  @override
  void initState() {
    super.initState();
    fetchProfile();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered =
        selectedCategory == 'All Shoes'
            ? products
            : products.where((p) => p['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: bg1Color,   // <-- WARNA UTAMA GELAP
      body: SafeArea(
        child: loadingProduct
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView(
                children: [
                  // ============================
                  // HEADER
                  // ============================
                  Container(
                    margin: EdgeInsets.only(
                      top: defaultMargin,
                      left: defaultMargin,
                      right: defaultMargin,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loadingProfile
                                    ? 'Hallo, User'
                                    : 'Hallo, ${profile?['name'] ?? "User"}',
                                style: primaryTextStyle.copyWith(
                                    fontSize: 24, fontWeight: semiBold),
                              ),
                              Text(
                                loadingProfile
                                    ? '@username'
                                    : '@${profile?['username'] ?? "-"}',
                                style: subtitleTextStyle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/image_profile.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ============================
                  // CATEGORY SELECTOR
                  // ============================
                  Container(
                    margin: EdgeInsets.only(top: defaultMargin),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'All Shoes',
                          'Running',
                          'Training',
                          'Basketball',
                          'Hiking',
                          'Football'
                        ].map((e) {
                          bool selected = selectedCategory == e;
                          return GestureDetector(
                            onTap: () => setState(() => selectedCategory = e),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              margin: EdgeInsets.only(
                                left: e == 'All Shoes' ? defaultMargin : 0,
                                right: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: selected ? primaryColor : Colors.transparent,
                                border: Border.all(
                                  color: selected
                                      ? Colors.transparent
                                      : subtitleTextColor,
                                ),
                              ),
                              child: Text(
                                e,
                                style: selected
                                    ? primaryTextStyle.copyWith(
                                        fontSize: 13, fontWeight: medium)
                                    : subtitleTextStyle.copyWith(
                                        fontSize: 13, fontWeight: medium),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // ============================
                  // PRODUCT SECTION
                  // ============================
                  Container(
                    margin: EdgeInsets.only(
                      top: defaultMargin,
                      left: defaultMargin,
                      right: defaultMargin,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ======= POPULAR PRODUCTS =======
                        if (selectedCategory == 'All Shoes') ...[
                          Text(
                            "Popular Products",
                            style: primaryTextStyle.copyWith(
                                fontSize: 22, fontWeight: semiBold),
                          ),
                          const SizedBox(height: 14),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: products
                                  .take(3)
                                  .map((p) => ProductCard(p))
                                  .toList(),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ======= NEW ARRIVALS =======
                          Text(
                            "New Arrivals",
                            style: primaryTextStyle.copyWith(
                                fontSize: 22, fontWeight: semiBold),
                          ),
                          const SizedBox(height: 14),
                          Column(
                            children: products
                                .map((p) => ProductTile(p))
                                .toList(),
                          ),
                        ] else ...[
                          Text(
                            "For You",
                            style: primaryTextStyle.copyWith(
                                fontSize: 22, fontWeight: semiBold),
                          ),
                          const SizedBox(height: 14),
                          filtered.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No items found",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Column(
                                  children: filtered
                                      .map((p) => ProductTile(p))
                                      .toList(),
                                ),
                        ]
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
      ),
    );
  }
}
