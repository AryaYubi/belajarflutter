// lib/pages/home/chat_page.dart (Diperbaiki)
import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  Widget chatContent(BuildContext context) { 
    // Widget yang menampilkan satu thread chat (Support)
    return GestureDetector(
      // Navigasi ke halaman chat detail
      onTap: () => Navigator.pushNamed(context, '/detail-chat'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: bg2Color))),
        child: Row(
          children: [
            Image.asset('assets/image_shop_logo.png', width: 54),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shoe Store', style: primaryTextStyle.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('Good night, This item is on...', style: secondaryTextStyle, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Text('Now', style: secondaryTextStyle.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget emptyChat(BuildContext context) { 
    // Tampilan jika tidak ada chat recent
    return Expanded(
      child: Container(
        color: bg3Color,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon_headset.png', width: 80),
            const SizedBox(height: 20),
            Text('Oops no message yet?', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
            const SizedBox(height: 12),
            Text('You have never done a transaction', style: secondaryTextStyle),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/home'), 
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Explore Store', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasChat = true; // Placeholder - ubah sesuai kondisi real nanti

    return Scaffold(
      backgroundColor: bg1Color,
      body: Column(
        children: [
          AppBar(
            backgroundColor: bg1Color,
            centerTitle: true,
            title: Text('Message Support', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          // Gunakan ternary operator untuk menghindari dead code
          hasChat
            ? Expanded(
                child: Container(
                  width: double.infinity,
                  color: bg3Color,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    children: [
                      chatContent(context), 
                    ],
                  ),
                ),
              )
            : emptyChat(context), 
        ],
      ),
    );
  }
}