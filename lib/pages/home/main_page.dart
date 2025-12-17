import 'package:flutter/material.dart';
import 'package:shamo/pages/home/chat_page.dart';
import 'package:shamo/pages/home/home_page.dart';
import 'package:shamo/pages/home/profile_page.dart';
import 'package:shamo/pages/home/wishlist_page.dart';
import 'package:shamo/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentIndex == 0 ? bg1Color : bg3Color,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        backgroundColor: secondaryColor,
        child: Image.asset('assets/icon_cart.png', width: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          clipBehavior: Clip.antiAlias,
          color: bg3Color, // Sesuai design original yang menggunakan bottomNav custom
          child: BottomNavigationBar(
            backgroundColor: bg3Color,
            currentIndex: currentIndex,
            onTap: (value) => setState(() => currentIndex = value),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
<<<<<<< Updated upstream
                icon: Image.asset('assets/icon_home.png', width: 21, color: currentIndex == 0 ? primaryColor : const Color(0xff808191)),
=======
                icon: Image.asset('assets/icon_home.png', 
                    width: 21, 
                    color: currentIndex == 0 ? primaryColor : subtitleTextColor),
>>>>>>> Stashed changes
                label: '',
              ),
              BottomNavigationBarItem(
<<<<<<< Updated upstream
                icon: Image.asset('assets/icon_chat.png', width: 20, color: currentIndex == 1 ? primaryColor : const Color(0xff808191)),
=======
                icon: Image.asset('assets/icon_chat.png', 
                    width: 20, 
                    color: currentIndex == 1 ? primaryColor : subtitleTextColor),
>>>>>>> Stashed changes
                label: '',
              ),
              BottomNavigationBarItem(
<<<<<<< Updated upstream
                icon: Image.asset('assets/icon_wishlist.png', width: 20, color: currentIndex == 2 ? primaryColor : const Color(0xff808191)),
=======
                icon: Image.asset('assets/icon_wishlist.png', 
                    width: 20, 
                    color: currentIndex == 2 ? primaryColor : subtitleTextColor),
>>>>>>> Stashed changes
                label: '',
              ),
              BottomNavigationBarItem(
<<<<<<< Updated upstream
                icon: Image.asset('assets/icon_profile.png', width: 18, color: currentIndex == 3 ? primaryColor : const Color(0xff808191)),
=======
                icon: Image.asset('assets/icon_profile.png', 
                    width: 18, 
                    color: currentIndex == 3 ? primaryColor : subtitleTextColor),
>>>>>>> Stashed changes
                label: '',
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomePage(),
          ChatPage(),
          WishlistPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}