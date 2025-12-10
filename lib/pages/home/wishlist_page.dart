import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/wishlist_card.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk wishlist
    final List<Map<String, dynamic>> wishlistItems = [
      {'name': 'Terrex Urban Low', 'price': 143.98, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a6381273949f4c33b708aae101235e95_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_01_standard.jpg'},
      {'name': 'Predator 20.3 Firm', 'price': 68.47, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/83906a596041492ba262ab9e01168f2d_9366/Predator_Mutator_20.1_Firm_Ground_Boots_Black_EF1629_01_standard.jpg'},
    ];

    return Column(
      children: [
        AppBar(
          backgroundColor: bg1Color,
          centerTitle: true,
          title: Text('Favorite Shoes', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        Expanded(
          child: Container(
            color: bg3Color,
            child: wishlistItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon_wishlist.png', width: 74, color: secondaryColor),
                        const SizedBox(height: 23),
                        Text(' You don\'t have dream shoes?', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
                      ],
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    children: wishlistItems.map((item) => WishlistCard(item)).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}