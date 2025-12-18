import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/product_card.dart';
import 'package:shamo/widgets/product_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  final supabase = Supabase.instance.client;
  late ScrollController _popularProductsScrollController;

  // ============================
  // PROFILE STREAM
  // ============================
  Map<String, dynamic>? profile;
  bool loadingProfile = true;

  Future<void> fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final res = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (!mounted) return;

      setState(() {
        profile = res;
        loadingProfile = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loadingProfile = false);
      debugPrint('Error fetching profile: $e');
    }
  }

  // ============================
  // PRODUCTS
  // ============================
  String selectedCategory = 'All Shoes';
  bool loadingProduct = true;
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> topSellingProducts = [];

  Future<void> fetchProducts() async {
    try {
      final res = await supabase.from('products').select();
      
      if (!mounted) return;

      setState(() {
        products = List<Map<String, dynamic>>.from(res);
      });
      
      // Fetch top selling products
      await _fetchTopSellingProducts();
      
      if (!mounted) return;
      setState(() {
        loadingProduct = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loadingProduct = false);
      debugPrint('Error loading products: $e');
    }
  }

  Future<void> _fetchTopSellingProducts() async {
    try {
      // Fetch all transaction items with product_id
      final transactionItems = await supabase
          .from('transaction_items')
          .select('product_id, quantity');

      if (transactionItems.isEmpty) {
        if (!mounted) return;
        setState(() {
          topSellingProducts = products.take(5).toList();
        });
        return;
      }

      // Group by product_id and sum quantities
      final Map<int, int> salesMap = {};

      for (var item in transactionItems) {
        final productId = item['product_id'] as int;
        final quantity = item['quantity'] as int;
        salesMap[productId] = (salesMap[productId] ?? 0) + quantity;
      }

      // Sort by sales (descending) and get top 5 product IDs
      final topProductIds = salesMap.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value))
          ;
      
      final topIds = topProductIds
          .take(5)
          .map((e) => e.key)
          .toList();

      if (topIds.isEmpty) {
        if (!mounted) return;
        setState(() {
          topSellingProducts = products.take(5).toList();
        });
        return;
      }

      // Get full product details for top selling products using a single query
      final topProducts = await supabase
          .from('products')
          .select()
          .inFilter('id', topIds);

      if (!mounted) return;

      // Sort the results to match the sales order
      final sortedTopProducts = <Map<String, dynamic>>[];
      for (var id in topIds) {
        final product = topProducts.firstWhere(
          (p) => p['id'] == id,
          orElse: () => {},
        );
        if (product.isNotEmpty) {
          sortedTopProducts.add(Map<String, dynamic>.from(product));
        }
      }

      setState(() {
        topSellingProducts = sortedTopProducts;
      });
    } catch (e) {
      debugPrint('Error fetching top selling products: $e');
      // Fallback to first 5 products
      if (!mounted) return;
      setState(() {
        topSellingProducts = products.take(5).toList();
      });
    }
  }

  // ============================
  // REFRESH FUNCTION
  // ============================
  Future<void> _refreshAll() async {
    setState(() {
      loadingProfile = true;
      loadingProduct = true;
    });
    await Future.wait([
      fetchProfile(),
      fetchProducts(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _popularProductsScrollController = ScrollController();
    _refreshAll();
  }

  @override
  void dispose() {
    _popularProductsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered = selectedCategory == 'All Shoes'
        ? products
        : products.where((p) => p['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: bg1Color,
      body: SafeArea(
        child: loadingProduct
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView(
                children: [
                  // HEADER
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
                                style: subtitleTextStyle.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        // REFRESH BUTTON
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Color(0xff504F5E)),
                          onPressed: _refreshAll,
                        ),
                      ],
                    ),
                  ),

                  // CATEGORY SELECTOR
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
                          'Hiking'
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
                                color:
                                    selected ? primaryColor : Colors.transparent,
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

                  // PRODUCT SECTION
                  Container(
                    margin: EdgeInsets.only(
                      top: defaultMargin,
                      left: defaultMargin,
                      right: defaultMargin,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedCategory == 'All Shoes') ...[
                          Text(
                            "Popular Products",
                            style: primaryTextStyle.copyWith(
                                fontSize: 22, fontWeight: semiBold),
                          ),
                          const SizedBox(height: 14),
                          SingleChildScrollView(
                            reverse: true,
                            controller: _popularProductsScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: topSellingProducts.map((p) => ProductCard(p)).toList(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "New Arrivals",
                            style: primaryTextStyle.copyWith(
                                fontSize: 22, fontWeight: semiBold),
                          ),
                          const SizedBox(height: 14),
                          Column(
                            children: products.map((p) => ProductTile(p)).toList(),
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
                                  children:
                                      filtered.map((p) => ProductTile(p)).toList(),
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