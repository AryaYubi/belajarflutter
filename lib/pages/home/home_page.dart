import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/product_card.dart';
import 'package:shamo/widgets/product_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All Shoes';

  // Data Dummy dari kode asli
  final List<Map<String, dynamic>> products = [
    {'name': 'Terrex Urban Low', 'cat': 'Hiking', 'price': 143.98, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a6381273949f4c33b708aae101235e95_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_01_standard.jpg'},
    {'name': 'Ultra 4D 5 Shoes', 'cat': 'Running', 'price': 285.73, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c20573e88107406e8854af6a01423455_9366/Ultra_4D_Shoes_Black_GX6366_01_standard.jpg'},
    {'name': 'SL 20 Shoes', 'cat': 'Running', 'price': 123.82, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/28e3b092323e449c8369aabc00d07412_9366/SL20_Shoes_Black_EG1144_01_standard.jpg'},
    {'name': 'Dame 7 Shoes', 'cat': 'Basketball', 'price': 125.71, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/5e090623126f43708e33ac4c010a3407_9366/Dame_7_Extply_Shoes_Blue_GV9872_01_standard.jpg'},
    {'name': 'Lego Sport Shoes', 'cat': 'Training', 'price': 92.72, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c690225102a04870bf02ac2e01237c22_9366/adidas_x_LEGO(r)_Sport_Shoes_Red_FY8440_01_standard.jpg'},
    {'name': 'Predator 20.3 Firm', 'cat': 'Football', 'price': 68.47, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/83906a596041492ba262ab9e01168f2d_9366/Predator_Mutator_20.1_Firm_Ground_Boots_Black_EF1629_01_standard.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = selectedCategory == 'All Shoes'
        ? products
        : products.where((p) => p['cat'] == selectedCategory).toList();

<<<<<<< Updated upstream
    return SafeArea(
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: defaultMargin, left: defaultMargin, right: defaultMargin),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hallo, Alex', style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold)),
                      Text('@alexkeinn', style: subtitleTextStyle.copyWith(fontSize: 16)),
                    ],
=======
    return Scaffold(
      backgroundColor: bg1Color,
      body: SafeArea(
        child: loadingProduct
          ? Center(child: CircularProgressIndicator(color: primaryTextColor))
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
                          icon: Icon(Icons.refresh, color: subtitleTextColor),
                          onPressed: _refreshAll,
                        ),
                      ],
                    ),
>>>>>>> Stashed changes
                  ),
                ),
                Container(
                  width: 54, height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage('assets/image_profile.png')),
                  ),
                ),
              ],
            ),
          ),
          
          // Categories
          Container(
            margin: EdgeInsets.only(top: defaultMargin),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All Shoes', 'Running', 'Training', 'Basketball', 'Hiking'].map((e) {
                  bool isSelected = selectedCategory == e;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = e),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: EdgeInsets.only(left: e == 'All Shoes' ? defaultMargin : 0, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? primaryColor : Colors.transparent,
                        border: Border.all(color: isSelected ? Colors.transparent : subtitleTextColor),
                      ),
                      child: Text(e, style: isSelected ? primaryTextStyle.copyWith(fontSize: 13, fontWeight: medium) : subtitleTextStyle.copyWith(fontSize: 13, fontWeight: medium)),
                    ),
<<<<<<< Updated upstream
                  );
                }).toList(),
=======
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
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  products.take(3).map((p) => ProductCard(p)).toList(),
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
                              ? Center(
                                  child: Text(
                                    "No items found",
                                    style: primaryTextStyle,
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
>>>>>>> Stashed changes
              ),
            ),
          ),

          // Product Logic
          Container(
            margin: EdgeInsets.only(top: defaultMargin, left: defaultMargin, right: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedCategory == 'All Shoes') ...[
                  Text('Popular Products', style: primaryTextStyle.copyWith(fontSize: 22, fontWeight: semiBold)),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: products.take(3).map((p) => ProductCard(p)).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('New Arrivals', style: primaryTextStyle.copyWith(fontSize: 22, fontWeight: semiBold)),
                  const SizedBox(height: 14),
                  Column(children: products.map((p) => ProductTile(p)).toList()),
                ] else ...[
                  Text('For You', style: primaryTextStyle.copyWith(fontSize: 22, fontWeight: semiBold)),
                  const SizedBox(height: 14),
                  filteredProducts.isEmpty
                      ? const Center(child: Text("No items found", style: TextStyle(color: Colors.white)))
                      : Column(children: filteredProducts.map((p) => ProductTile(p)).toList()),
                ]
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}