import 'package:flutter/material.dart';
import 'package:shamo/pages/home/chat_page.dart'; // Import ChatPage
import 'package:shamo/pages/home/home_page.dart'; // Import HomePage
import 'package:shamo/pages/home/profile_page.dart'; // Import ProfilePage
import 'package:shamo/pages/home/wishlist_page.dart'; // Import WishlistPage
import 'package:shamo/theme.dart'; // Import custom theme

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0; // Index untuk mengontrol halaman mana yang sedang aktif

  @override
  Widget build(BuildContext context) {
    
    // Logika untuk menentukan warna background body (berubah sesuai tab aktif)
    return Scaffold(
      backgroundColor: currentIndex == 0 ? bg1Color : bg3Color, 
      
      // ==========================================================
      // FLOATING ACTION BUTTON (CART BUTTON)
      // ==========================================================
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'), // Navigasi ke Cart Page
        backgroundColor: secondaryColor,
        child: Image.asset('assets/icon_cart.png', width: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // ==========================================================
      // BOTTOM NAVIGATION BAR
      // ==========================================================
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          clipBehavior: Clip.antiAlias,
          color: bg3Color, 
          child: BottomNavigationBar(
            backgroundColor: bg3Color,
            currentIndex: currentIndex,
            // Mengubah index aktif saat item diklik
            onTap: (value) => setState(() => currentIndex = value), 
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              // 1. HOME (Index 0)
              BottomNavigationBarItem(
                icon: Image.asset('assets/icon_home.png', 
                    width: 21, 
                    color: currentIndex == 0 ? primaryColor : const Color(0xff808191)),
                label: '',
              ),
              // 2. CHAT (Index 1) - Sekarang Aktif!
              BottomNavigationBarItem(
                icon: Image.asset('assets/icon_chat.png', 
                    width: 20, 
                    color: currentIndex == 1 ? primaryColor : const Color(0xff808191)),
                label: '',
              ),
              // 3. WISH LIST (Index 2)
              BottomNavigationBarItem(
                icon: Image.asset('assets/icon_wishlist.png', 
                    width: 20, 
                    color: currentIndex == 2 ? primaryColor : const Color(0xff808191)),
                label: '',
              ),
              // 4. PROFILE (Index 3)
              BottomNavigationBarItem(
                icon: Image.asset('assets/icon_profile.png', 
                    width: 18, 
                    color: currentIndex == 3 ? primaryColor : const Color(0xff808191)),
                label: '',
              ),
            ],
          ),
        ),
      ),
      
      // ==========================================================
      // BODY (INDEXED STACK UNTUK MENGGANTI HALAMAN)
      // ==========================================================
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomePage(),
          ChatPage(), // Halaman Chat List
          WishlistPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}