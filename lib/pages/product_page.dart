import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int currentIndex = 0;
  bool isWishlist = false;
  final List<String> images = [
    'assets/image_shoes.png',
    'assets/image_shoes.png',
    'assets/image_shoes.png',
  ];

  @override
  Widget build(BuildContext context) {
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
                  Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close, color: primaryTextColor))),
                  Image.asset('assets/icon_success.png', width: 100),
                  const SizedBox(height: 12),
                  Text('Hurray :)', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: semiBold)),
                  const SizedBox(height: 12),
                  Text('Item added successfully', style: secondaryTextStyle),
                  const SizedBox(height: 20),
                  CustomButton(text: 'View My Cart', onPressed: () => Navigator.pushNamed(context, '/cart'), width: 154),
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
                height: 350, // Image Carousel area
                child: PageView.builder(
                   itemCount: images.length,
                   onPageChanged: (index) => setState(() => currentIndex = index),
                   itemBuilder: (context, index) => Image.asset(images[index], fit: BoxFit.cover),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.chevron_left)),
                    const Icon(Icons.shopping_bag, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: images.asMap().entries.map((entry) => indicator(entry.key)).toList()),
          
          // Content
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TERREX URBAN LOW', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: semiBold)),
                          Text('Hiking', style: secondaryTextStyle.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => isWishlist = !isWishlist),
                      child: Image.asset(isWishlist ? 'assets/button_wishlist_blue.png' : 'assets/button_wishlist.png', width: 46),
                    ),
                  ],
                ),
                // Price & Description ...
                const SizedBox(height: 20),
                Text('Description', style: primaryTextStyle.copyWith(fontWeight: medium)),
                const SizedBox(height: 12),
                Text('Unpaved trails and mixed surfaces are easy when you have the traction and support you need.', style: secondaryTextStyle.copyWith(fontWeight: light), textAlign: TextAlign.justify),
                const SizedBox(height: 30),
                // Buttons
                Row(
                  children: [
                    Container(
                      width: 54, height: 54,
                      decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/detail-chat'), child: Icon(Icons.chat, color: primaryColor)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(text: 'Add to Cart', onPressed: showSuccessDialog),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}